module orelang.operator.DllOperator;
import orelang.operator.IOperator, orelang.Engine, orelang.Value;
import orelang.Util;
import core.sys.posix.dlfcn;
import std.string, std.stdio, std.format, std.conv;

version (WithFFI) {
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
    return [&ffi_type_void, &ffi_type_uint8, &ffi_type_sint8,
      &ffi_type_uint16, &ffi_type_sint16, &ffi_type_uint32,
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
      final switch (type) with (D_TYPE) {
      case VOID:
        break;
      case UBYTE:
        if (!checkCastable!(ubyte)(args[i])) {
          throw new Error("Invalid argument<type error>");
        }
        break;
      case BYTE:
        if (!checkCastable!(byte)(args[i])) {
          throw new Error("Invalid argument<type error>");
        }
        break;
      case USHORT:
        if (!checkCastable!(ushort)(args[i])) {
          throw new Error("Invalid argument<type error>");
        }
        break;
      case SHORT:
        if (!checkCastable!(short)(args[i])) {
          throw new Error("Invalid argument<type error>");
        }
        break;
      case UINT:
        if (!checkCastable!(uint)(args[i])) {
          throw new Error("Invalid argument<type error>");
        }
        break;
      case INT:
        if (!checkCastable!(int)(args[i])) {
          throw new Error("Invalid argument<type error>");
        }
        break;
      case ULONG:
        if (!checkCastable!(ulong)(args[i])) {
          throw new Error("Invalid argument<type error>");
        }
        break;
      case LONG:
        if (!checkCastable!(long)(args[i])) {
          throw new Error("Invalid argument<type error>");
        }
        break;
      case FLOAT:
        if (!checkCastable!(float)(args[i])) {
          throw new Error("Invalid argument<type error>");
        }
        break;
      case DOUBLE:
        if (!checkCastable!(double)(args[i])) {
          throw new Error("Invalid argument<type error>");
        }
        break;
      case POINTER:
        if (!checkCastable!(void)(args[i])) {
          throw new Error("Invalid argument<type error>");
        }
        break;
      case STRING:
        if (!checkCastable!(char)(args[i])) {
          throw new Error("Invalid argument<type error>");
        }
        break;
      }
    }

    ffi_arg result;

    ffi_call(&func.cif, func.ptr, &result, cast(void**)args);

    final switch (func.r_type) with (D_TYPE) {
    case VOID:
      return new Value;
    case UBYTE:
      auto v = cast(ubyte)result;
      return new Value(v);
    case BYTE:
      auto v = cast(byte)result;
      return new Value(v);
    case USHORT:
      auto v = cast(ushort)result;
      return new Value(v);
    case SHORT:
      auto v = cast(short)result;
      return new Value(v);
    case UINT:
      auto v = cast(uint)result;
      return new Value(v);
    case INT:
      auto v = cast(int)result;
      return new Value(v);
    case ULONG:
      auto v = cast(ulong)result;
      return new Value(v);
    case LONG:
      auto v = cast(long)result;
      return new Value(v);
    case FLOAT:
      auto v = cast(float)result;
      return new Value(v);
    case DOUBLE:
      auto v = cast(double)result;
      return new Value(v);
    case POINTER:
      void* ptr = cast(void*)result;
      return new Value(ptr);
    case STRING:
      auto v = cast(char*)result;
      return new Value(cast(string)v.fromStringz);
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
          throw new Error("<dll_op call>Invalid argument");
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
              Value eargs = engine.eval(args[i]);

              final switch (arg_type) with (D_TYPE) {
              case VOID:
                break;
              case UBYTE:
                if (eargs.type != ValueType.Numeric) {
                  throw new Error("<ubyte>Invalid Argument");
                }
                auto arg = eargs.getNumeric.to!(ubyte);
                auto ptr = &arg;
                f_args ~= ptr;
                break;
              case BYTE:
                if (eargs.type != ValueType.Numeric) {
                  throw new Error("<byte>Invalid Argument");
                }
                auto arg = eargs.getNumeric.to!(byte);
                auto ptr = &arg;
                f_args ~= ptr;
                break;
              case USHORT:
                if (eargs.type != ValueType.Numeric) {
                  throw new Error("<ushort>Invalid Argument");
                }
                auto arg = eargs.getNumeric.to!(ushort);
                auto ptr = &arg;
                f_args ~= ptr;
                break;
              case SHORT:
                if (eargs.type != ValueType.Numeric) {
                  throw new Error("<short>Invalid Argument");
                }
                auto arg = eargs.getNumeric.to!(short);
                auto ptr = &arg;
                f_args ~= ptr;
                break;
              case UINT:
                if (eargs.type != ValueType.Numeric) {
                  throw new Error("<uint>Invalid Argument");
                }
                auto arg = eargs.getNumeric.to!(uint);
                auto ptr = &arg;
                f_args ~= ptr;
                break;
              case INT:
                if (eargs.type != ValueType.Numeric) {
                  throw new Error("<int>Invalid Argument");
                }
                auto arg = eargs.getNumeric.to!(int);
                auto ptr = &arg;
                f_args ~= ptr;
                break;
              case ULONG:
                if (eargs.type != ValueType.Numeric) {
                  throw new Error("<ulong>Invalid Argument");
                }
                auto arg = eargs.getNumeric.to!(ulong);
                auto ptr = &arg;
                f_args ~= ptr;
                break;
              case LONG:
                if (eargs.type != ValueType.Numeric) {
                  throw new Error("<long>Invalid Argument");
                }
                auto arg = eargs.getNumeric.to!(long);
                auto ptr = &arg;
                f_args ~= ptr;
                break;
              case FLOAT:
                if (eargs.type != ValueType.Numeric) {
                  throw new Error("<float>Invalid Argument");
                }
                auto arg = eargs.getNumeric.to!(float);
                auto ptr = &arg;
                f_args ~= ptr;
                break;
              case DOUBLE:
                if (eargs.type != ValueType.Numeric) {
                  throw new Error("<double>Invalid Argument");
                }
                auto arg = eargs.getNumeric.to!(double);
                auto ptr = &arg;
                f_args ~= ptr;
                break;
              case POINTER:
                if (eargs.type != ValueType.RAWPointer) {
                  throw new Error("<ptr>Invalid Argument");
                }
                auto arg = eargs.getRAWPointer;
                void* ptr = &arg;
                f_args ~= ptr;
                break;
              case STRING:
                if (eargs.type != ValueType.String) {
                  throw new Error("<string>Invalid Argument");
                }
                auto arg = eargs.getString.toStringz;
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
}
