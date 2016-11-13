module orelang.Value;
import orelang.expression.ImmediateValue,
       orelang.expression.SymbolValue,
       orelang.operator.DynamicOperator,
       orelang.expression.IExpression,
       orelang.operator.ClassType,
       orelang.operator.IOperator,
       orelang.Closure;
import std.algorithm,
       std.exception,
       std.array,
       std.traits,
       std.regex,
       std.conv;

enum ValueType {
  ImmediateValue,
  SymbolValue,
  IExpression,
  ClassType,
  IOperator,
  Closure,
  HashMap,
  Numeric,
  String,
  Ubyte,
  Bool,
  Null,
  Array
}

class Value {
  ValueType type;

  private {
    double  numeric_value;
    string  string_value;
    bool    bool_value;
    ubyte   ubyte_value;
    Value[] array_value;
    ImmediateValue imv_value;
    SymbolValue sym_value;
    IExpression ie_value;
    ClassType class_value;
    IOperator io_value;
    Closure closure_value;
    Value[string] hashmap_value;
  }

  this()               { this.type = ValueType.Null; }
  this(ValueType type) { this.type = type; }
  this(T)(T value) if (isNumeric!T) { this.opAssign(value); }
  this(string value)  { this.opAssign(value); }
  this(bool value)    { this.opAssign(value); }
  this(ubyte value)   {
    this.init;
    this.ubyte_value = value;
    this.type        = ValueType.Ubyte;
  }
  this(Value[] value) { this.opAssign(value); }
  this(ImmediateValue value) {
    this.init;
    this.imv_value = value;
    this.type      = ValueType.ImmediateValue; }
  this(SymbolValue value) {
    this.init;
    this.sym_value = value;
    this.type      = ValueType.SymbolValue; }
  this(IExpression value)    { this.opAssign(value); }
  this(ClassType value)      { this.opAssign(value); }
  this(IOperator value)      { this.opAssign(value); }
  this(Closure value)        { this.opAssign(value); }
  this(Value[string] value)  { this.opAssign(value); }

  double  getNumeric() { enforce(this.type == ValueType.Numeric);
                         return this.numeric_value; }
  string  getString()  { enforce(this.type == ValueType.String || this.type == ValueType.SymbolValue);
                         return this.type == ValueType.String ? this.string_value : this.sym_value.value; }
  bool    getBool()    { enforce(this.type == ValueType.Bool);
                         return this.bool_value; }
  ubyte   getUbyte()  { enforce(this.type == ValueType.Ubyte);
                         return this.ubyte_value; }
  auto    getNull()    { throw new Error("Can't get from NULL value"); }
  Value[] getArray()   { enforce(this.type == ValueType.Array);
                         return this.array_value; }
  ImmediateValue getImmediateValue() { enforce(this.type == ValueType.ImmediateValue);
                                       return this.imv_value; }
  SymbolValue    getSymbolValue()    { enforce(this.type == ValueType.SymbolValue);
                                       return this.sym_value; }
  IExpression    getIExpression()    { enforce(this.type == ValueType.IExpression);
                                       return this.ie_value; }
  ClassType      getClassType()      { enforce(this.type == ValueType.ClassType);
                                       return this.class_value; }
  IOperator      getIOperator()      { enforce(this.type == ValueType.IOperator);
                                       return this.io_value; }
  Closure        getClosure()        { enforce(this.type == ValueType.Closure);
                                       return this.closure_value; }
  Value[string]   getHashMap()        { enforce(this.type == ValueType.HashMap);
                                       return this.hashmap_value; }

  void opAssign(T)(T value) if (isNumeric!T) {
    this.init;
    this.numeric_value = value;
    this.type = ValueType.Numeric;
  }

  void opAssign(T)(T value) if (is(T == string)) {
    this.init;
    this.string_value = value;
    this.type         = ValueType.String;
  }

  void opAssign(bool value) {
    this.init;
    this.bool_value = value;
    this.type       = ValueType.Bool;
  }

  void opAssign(T)(T[] value) if (is(T == Value)) {
    this.init;
    this.array_value = value;
    this.type        = ValueType.Array;
  }

  void opAssign(T)(T[] value) if (!is(T == Value) && !is(T == immutable(char))) {
    this.init;
    this.array_value = [];

    foreach (e; value) this.array_value ~= new Value(e);

    this.type        = ValueType.Array;
  }

  void opAssign(IExpression value) {
    this.init;
    this.ie_value = value;
    this.type     = ValueType.IExpression;
  }

  void opAssign(ClassType value) {
    this.init;
    this.class_value = value;
    this.type        = ValueType.ClassType;
  }

  void opAssign(IOperator value) {
    this.init;
    this.io_value = value;
    this.type     = ValueType.IOperator;
  }

  void opAssign(Closure value) {
    this.init;
    this.closure_value = value;
    this.type          = ValueType.Closure;
  }

  void opAssign(Value[string] value) {
    this.init;
    this.hashmap_value = value;
    this.type          = ValueType.HashMap; 
  }

  override string toString() {
    final switch(this.type) with (ValueType) {
      case Numeric: return this.numeric_value.to!string;
      case String:  return this.string_value;
      case Bool:    return this.bool_value.to!string;
      case Ubyte:   return this.ubyte_value.to!string;
      case Null:    return "null";
      case Array:   return "[" ~ this.array_value.map!(value => value.toString).array.join(", ") ~ "]";
      case HashMap: return this.hashmap_value.to!string;
      case ImmediateValue: return this.imv_value.toString;
      case SymbolValue:    return this.sym_value.value;
      case IExpression:    return this.ie_value.stringof;
      case ClassType:      return this.class_value.stringof;
      case IOperator:      return this.io_value.stringof;
      case Closure:        return this.closure_value.stringof;
    }
  }

  void addTo(Value value) {
    enforce(this.type == value.type && value.type == ValueType.Numeric);
    this.numeric_value += value.getNumeric;
  }

  void subTo(Value value) {
    enforce(this.type == value.type && value.type == ValueType.Numeric);
    this.numeric_value -= value.getNumeric;
  }

  void mulTo(Value value) {
    enforce(this.type == value.type && value.type == ValueType.Numeric);
    this.numeric_value *= value.getNumeric;
  }

  void divTo(Value value) {
    enforce(this.type == value.type && value.type == ValueType.Numeric);
    this.numeric_value /= value.getNumeric;
  }

  void modTo(Value value) {
    enforce(this.type == value.type && value.type == ValueType.Numeric);
    this.numeric_value %= value.getNumeric;
  }

  Value opBinary(string op)(Value value) if (op == "+") {
    enforce(value.type == ValueType.Numeric);
    return new Value(this.numeric_value + value.getNumeric);
  }

  Value opBinary(string op)(Value value) if (op == "-") {
    enforce(value.type == ValueType.Numeric);

    return new Value(this.numeric_value - value.getNumeric);
  }

  Value opBinary(string op)(Value value) if (op == "*") {
    enforce(value.type == ValueType.Numeric);
    return new Value(this.numeric_value * value.getNumeric);
  }

  Value opBinary(string op)(Value value) if (op == "/") {
    enforce(value.type == ValueType.Numeric);
    return new Value(this.numeric_value / value.getNumeric);
  }

  Value opBinary(string op)(Value value) if (op == "%") {
    enforce(value.type == ValueType.Numeric);
    return new Value(this.numeric_value % value.getNumeric);
  }

  void init() {
    if (this.type != ValueType.Null) {
      if (this.type == ValueType.Numeric) { this.numeric_value = 0;  }
      if (this.type == ValueType.String)  { this.string_value  = ""; }
      if (this.type == ValueType.Array)   { this.array_value   = []; }
      if (this.type == ValueType.Bool)    { this.bool_value    = false; }
      if (this.type == ValueType.Ubyte)   { this.ubyte_value   = 0;  }
      if (this.type == ValueType.ImmediateValue) { this.imv_value = null; }
      if (this.type == ValueType.SymbolValue)    { this.sym_value = null; }
      if (this.type == ValueType.IExpression)    { this.ie_value  = null; }
      if (this.type == ValueType.ClassType)      { this.class_value  = null; }
      if (this.type == ValueType.IOperator)      { this.io_value  = null; }
      if (this.type == ValueType.Closure)        { this.closure_value = null; }
      if (this.type == ValueType.HashMap)        { this.hashmap_value = null; }

      this.type = ValueType.Null;
    }
  }

  Value opIndex() {
    enforce(this.type == ValueType.Array);

    return new Value;
  }

  Value opIndex(size_t idx) {
    enforce(this.type == ValueType.Array);

    if (!(idx < this.array_value.length)) {
      throw new Error("Out of index of the Array, orded - " ~ idx.to!string ~ " but length of the array is " ~ this.array_value.length.to!string);
    }

    return this.array_value[idx];
  }

  Value opIndex(Value value) {
    enforce(this.type == ValueType.HashMap);

    if (value.getString !in this.hashmap_value) {
      throw new Error("No such a key in the hash, key - " ~ value.toString ~ ", hash - " ~ this.hashmap_value.stringof);
    }

    return this.hashmap_value[value.getString];
  }

  override bool opEquals(Object _value) {
    if ((cast(Value)_value) is null) {
      throw new Error("Can not compare between incompatibility");
    }

    Value value = cast(Value)_value;

    if (this.type != value.type) {
      throw new Error("Can not compare between incompatibility type " ~ this.type.to!string ~ " and " ~ value.type.to!string);
    }

    final switch(this.type) with (ValueType) {
      case ImmediateValue:
        throw new Error("Can't compare with ImmediateValue");
      case SymbolValue:
        return this.sym_value.value == value.getSymbolValue.value;
      case IExpression:
        throw new Error("Can't compare with IExpression");
      case ClassType:
        throw new Error("Can't compare with ClassType");
      case IOperator:
        throw new Error("Can't compare with IOperator");
      case Closure:
        throw new Error("Can't compare with Closure");
      case HashMap:
        throw new Error("Can't compare with HashMap");
      case Numeric:
        return this.numeric_value == value.numeric_value;
      case String:
        return this.string_value == value.string_value;
      case Bool:
        return this.bool_value == value.bool_value;
      case Ubyte:
        return this.ubyte_value == value.ubyte_value;
      case Null:
        throw new Error("Can't compare with Null");
      case Array:
        Value[] a = this.getArray,
                b = value.getArray;

        if (a.length != b.length) {
          return false;
        }

        foreach (idx; 0..(a.length)) {
          if (a[idx].opCmp(b[idx]) != 0) { return false; }
        }

        return true;
    }
  }

  override int opCmp(Object _value) {
    if ((cast(Value)_value) is null) {
      throw new Error("Can not compare between incompatibility");
    }

    Value value = cast(Value)_value;

    if (this.type != value.type) {
      throw new Error("Can not compare between incompatibility type " ~ this.type.to!string ~ " and " ~ value.type.to!string);
    }

    final switch(this.type) with (ValueType) {
      case ImmediateValue:
        throw new Error("Can't compare with ImmediateValue");
      case SymbolValue:
        auto c = this.sym_value.value,
             d = value.getSymbolValue.value;
        if (c == d) { return 0; }
        if (c < d)  { return -1; }
        return 1;
      case IExpression:
        throw new Error("Can't compare with IExpression");
      case ClassType:
        throw new Error("Can't compare with ClassType");
      case IOperator:
        throw new Error("Can't compare with IOperator");
      case Closure:
        throw new Error("Can't compare with Closure");
      case HashMap:
        throw new Error("Can't compare with HashMap");
      case Numeric:
        auto c = this.numeric_value,
             d = value.numeric_value;

        if (c == d) { return 0;  }
        if (c < d)  { return -1; }
        return 1;
      case String:
        auto c = this.string_value,
             d = value.string_value;

        if (c == d) { return 0;  }
        if (c < d)  { return -1; }
        return 1;
      case Ubyte:
        auto c = this.ubyte_value,
             d = value.ubyte_value;

        if (c == d) { return 0;  }
        if (c < d)  { return -1; }
        return 1;
      case Bool:
        throw new Error("Can't compare with Bool");
      case Null:
        throw new Error("Can't compare with Null");
      case Array:
        Value[] a = this.getArray,
                b = value.getArray;

        if (a.length != b.length) {
          throw new Error("Can't compare between different size array");
        }

        foreach (idx; 0..(a.length)) {
          if (a[idx].opCmp(b[idx]) != 0) { return 1; }
        }

        return 0;
    }
  }

  Value dup() {
    final switch (this.type) with (ValueType) {
      case ImmediateValue:
        return new Value(this.imv_value);
      case SymbolValue:
        return new Value(this.sym_value);
      case IExpression:
        return new Value(this.ie_value);
      case ClassType:
        return new Value(this.class_value);
      case IOperator:
        return new Value(this.io_value);
      case Closure:
        return new Value(this.closure_value);
      case HashMap:
        return new Value(this.hashmap_value);
      case Numeric:
        return new Value(this.numeric_value);
      case String:
        return new Value(this.string_value);
      case Bool:
        return new Value(this.bool_value);
      case Ubyte:
        return new Value(this.ubyte_value);
      case Null:
        return new Value;
      case Array:
        return new Value(this.array_value.dup);
    }
  }
}
