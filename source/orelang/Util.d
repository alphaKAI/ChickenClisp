module orelang.Util;

extern (C) {
  struct ffi_type {
    size_t size;
    ushort alignment;
    ushort type;
    ffi_type** elements;
  }

  extern __gshared {
    ffi_type ffi_type_void;
    ffi_type ffi_type_uint8;
    ffi_type ffi_type_sint8;
    ffi_type ffi_type_uint16;
    ffi_type ffi_type_sint16;
    ffi_type ffi_type_uint32;
    ffi_type ffi_type_sint32;
    ffi_type ffi_type_uint64;
    ffi_type ffi_type_sint64;
    ffi_type ffi_type_float;
    ffi_type ffi_type_double;
    ffi_type ffi_type_pointer;

    ffi_type ffi_type_longdouble;
  }

  enum ffi_status {
    FFI_OK = 0,
    FFI_BAD_TYPEDEF,
    FFI_BAD_ABI
  }

  struct ffi_cif {
    ffi_abi abi;
    uint nargs;
    ffi_type** arg_types;
    ffi_type* rtype;
    uint bytes;
    uint flags;
  }

  alias ffi_arg = ulong;
  alias ffi_sarg = long;

  enum ffi_abi {
    FFI_FIRST_ABI = 0,
    FFI_SYSV,
    FFI_UNIX64, /* Unix variants all use the same ABI for x86-64  */
    FFI_THISCALL,
    FFI_FASTCALL,
    FFI_STDCALL,
    FFI_PASCAL,
    FFI_REGISTER,
    FFI_LAST_ABI,
    FFI_DEFAULT_ABI = FFI_UNIX64
  }

  ffi_status ffi_prep_cif(ffi_cif* cif, ffi_abi abi, uint nargs,
      ffi_type* rtype, ffi_type** atypes);

  ffi_status ffi_prep_cif_var(ffi_cif* cif, ffi_abi abi, uint nfixedargs,
      uint ntotalargs, ffi_type* rtype, ffi_type** atypes);

  void ffi_call(ffi_cif* cif, //void (*fn)(void),
      void* fn, void* rvalue, void** avalue);
}
