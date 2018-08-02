module orelang.operator.DllOperator;
import orelang.operator.IOperator, orelang.Engine, orelang.Value;
import orelang.Util;
import core.sys.posix.dlfcn;
import std.string, std.stdio, std.format, std.conv;

enum D_TYPE {
  VOID,
  UBYTE,
  BYTE,
  USHORT,
  SHORT,
  UINT,
  INT,
  ULONG,
  LONG,
  FLOAT,
  DOUBLE,
  POINTER,
  STRING,
}

D_TYPE string_to_dtype(string s) {
  final switch (s) with (D_TYPE) {
  case "void":
    return VOID;
  case "ubyte":
    return UBYTE;
  case "byte":
    return BYTE;
  case "ushort":
    return USHORT;
  case "short":
    return SHORT;
  case "uint":
    return UINT;
  case "int":
    return INT;
  case "ulong":
    return ULONG;
  case "long":
    return LONG;
  case "float":
    return FLOAT;
  case "double":
    return DOUBLE;
  case "pointer":
    return POINTER;
  case "string":
    return STRING;
  }
}

ffi_type* d_type_to_ffi_type(D_TYPE type) {
  return [&ffi_type_void, &ffi_type_uint8, &ffi_type_sint8, &ffi_type_uint16, &ffi_type_sint16, &ffi_type_uint32,
    &ffi_type_sint32, &ffi_type_uint64, &ffi_type_sint64, &ffi_type_float,
    &ffi_type_double, &ffi_type_pointer, &ffi_type_pointer][type];
}

ffi_type*[] d_types_to_ffi_types(D_TYPE[] types) {
  ffi_type*[] ret;
  foreach (type; types) {
    ret ~= d_type_to_ffi_type(type);
  }
  return ret;
}

struct Func {
  string name;
  void* ptr;
  D_TYPE[] arg_types;
  D_TYPE r_type;
  ffi_cif cif;
}

Func newFunc(void* lh, string name, D_TYPE[] arg_types, D_TYPE r_type) {
  import std.string;

  void* ptr = dlsym(lh, name.toStringz);
  char* error = dlerror();

  if (error) {
    throw new Error("dlsym error: %s\n".format(error));
  }

  ffi_cif cif;
  ffi_status status;

  auto _arg_types = d_types_to_ffi_types(arg_types);
  auto _r_type = d_type_to_ffi_type(r_type);

  if ((status = ffi_prep_cif(&cif, ffi_abi.FFI_DEFAULT_ABI,
      arg_types.length.to!uint, _r_type, cast(ffi_type**)_arg_types)) != ffi_status.FFI_OK) {
    throw new Error("ERROR : %d".format(status));
  }

  return Func(name, ptr, arg_types, r_type, cif);
}

bool checkCastable(T)(void* ptr) {
  return (cast(T*)ptr) !is null;
}

Value invokeFunc(Func func, void*[] args) {
  foreach (i, type; func.arg_types) {
    if (type == D_TYPE.INT) {
      if (!checkCastable!(int)(args[i])) {
        throw new Error("Invalid argument<type error>");
      }
    } else {
      throw new Error("Not Impl!");
    }
  }

  ffi_arg result;

  ffi_call(&func.cif, func.ptr, &result, cast(void**)args);

  if (func.r_type == D_TYPE.INT) {
    return new Value(result.to!int);
  } else {
    throw new Error("Not Impl!");
  }
}

class DllOperator : IOperator {
  /**
   * call
   */
  void*[] lhs;

  ~this() {
    foreach (lh; lhs) {
      dlclose(lh);
    }
  }

  void* open_dll(string dll_path) {
    void* lh = dlopen(dll_path.toStringz, RTLD_LAZY);
    if (!lh) {
      throw new Error("dlopen error: %s\n".format(dlerror()));
    }
    lhs ~= lh;
    return lh;
  }

  public Value call(Engine engine, Value[] args) {
    struct Func_Info {
      string name;
      D_TYPE r_type;
      D_TYPE[] arg_types;
    }

    string dll_path;
    Func_Info[] func_infos;

    foreach (arg; args) {
      if (arg.type == ValueType.Array) {
        Value[] array = arg.getArray;
        if (array[0].type != ValueType.SymbolValue) {
          throw new Error("<1>Invalid Syntax");
        }
        if (array[0].getSymbolValue.value == "dll-path") {
          if (array[1].type != ValueType.String) {
            throw new Error("<2>Invalid Syntax");
          }
          dll_path = array[1].getString;
        } else if (array[0].getSymbolValue.value == "dll-functions") {
          if (array[1].type != ValueType.Array) {
            throw new Error("<3>Invalid Syntax");
          }
          Value[] funcs = array[1 .. $];

          foreach (func; funcs) {
            if (func.type != ValueType.Array) {
              throw new Error("<4>Invalid Syntax");
            }
            Value[] info = func.getArray;
            if (info.length != 3) {
              throw new Error("<5>Invalid Syntax");
            }
            if (info[0].type != ValueType.String
                || info[1].type != ValueType.SymbolValue || info[2].type != ValueType.Array) {
              throw new Error("<6>Invalid Syntax");
            }
            string name = info[0].getString;
            D_TYPE r_type = info[1].getSymbolValue.value.string_to_dtype;
            D_TYPE[] arg_types;

            foreach (Value type; info[2].getArray) {
              if (type.type != ValueType.SymbolValue) {
                throw new Error("<7>Invalid Syntax");
              }
              arg_types ~= type.getSymbolValue.value.string_to_dtype;
            }

            func_infos ~= Func_Info(name, r_type, arg_types);
          }
        }
      } else {
        throw new Error("Invalid argument");
      }
    }

    if (dll_path.length == 0 || func_infos.length == 0) {
      throw new Error("Invalid Syntax");
    }

    void* lh = open_dll(dll_path);

    foreach (func_info; func_infos) {
      IOperator new_op = new class() IOperator {
        Func func;

        this() {
          func = newFunc(lh, func_info.name, func_info.arg_types, func_info.r_type);
        }

        ~this() {
          dlclose(lh);
        }

        public Value call(Engine engine, Value[] args) {
          void*[] f_args;
          foreach (i, arg_type; func.arg_types) {
            final switch (arg_type) with (D_TYPE) {
            case VOID:
              break;
            case UBYTE:
              if (args[i].type != ValueType.Numeric) {
                throw new Error("Invalid Argument");
              }
              auto arg = args[i].getNumeric.to!(ubyte);
              auto ptr = &arg;
              f_args ~= ptr;
              break;
            case BYTE:
              if (args[i].type != ValueType.Numeric) {
                throw new Error("Invalid Argument");
              }
              auto arg = args[i].getNumeric.to!(byte);
              auto ptr = &arg;
              f_args ~= ptr;
              break;
            case USHORT:
              if (args[i].type != ValueType.Numeric) {
                throw new Error("Invalid Argument");
              }
              auto arg = args[i].getNumeric.to!(ushort);
              auto ptr = &arg;
              f_args ~= ptr;
              break;
            case SHORT:
              if (args[i].type != ValueType.Numeric) {
                throw new Error("Invalid Argument");
              }
              auto arg = args[i].getNumeric.to!(short);
              auto ptr = &arg;
              f_args ~= ptr;
              break;
            case UINT:
              if (args[i].type != ValueType.Numeric) {
                throw new Error("Invalid Argument");
              }
              auto arg = args[i].getNumeric.to!(uint);
              auto ptr = &arg;
              f_args ~= ptr;
              break;
            case INT:
              if (args[i].type != ValueType.Numeric) {
                throw new Error("Invalid Argument");
              }
              auto arg = args[i].getNumeric.to!(int);
              auto ptr = &arg;
              f_args ~= ptr;
              break;
            case ULONG:
              if (args[i].type != ValueType.Numeric) {
                throw new Error("Invalid Argument");
              }
              auto arg = args[i].getNumeric.to!(ulong);
              auto ptr = &arg;
              f_args ~= ptr;
              break;
            case LONG:
              if (args[i].type != ValueType.Numeric) {
                throw new Error("Invalid Argument");
              }
              auto arg = args[i].getNumeric.to!(long);
              auto ptr = &arg;
              f_args ~= ptr;
              break;
            case FLOAT:
              if (args[i].type != ValueType.Numeric) {
                throw new Error("Invalid Argument");
              }
              auto arg = args[i].getNumeric.to!(float);
              auto ptr = &arg;
              f_args ~= ptr;
              break;
            case DOUBLE:
              if (args[i].type != ValueType.Numeric) {
                throw new Error("Invalid Argument");
              }
              auto arg = args[i].getNumeric.to!(double);
              auto ptr = &arg;
              f_args ~= ptr;
              break;
            case POINTER:
              throw new Error("Not impl!");
            case STRING:
              if (args[i].type != ValueType.String) {
                throw new Error("Invalid Argument");
              }
              string arg = args[i].getString;
              auto ptr = &arg;
              f_args ~= ptr;
              break;
            }
          }

          return invokeFunc(func, f_args);
        }
      };

      engine.defineVariable(func_info.name, new Value(new_op));
    }

    return new Value(true);
  }
}
