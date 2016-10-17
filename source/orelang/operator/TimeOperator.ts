import {Engine} from "../Engine";
import {IOperator, Operator} from "../operator/IOperator";

export class TimeOperator extends Operator implements IOperator {
  /**
   * call
   */
  public call(engine: Engine, args: Array<any>): Object {
    var microtime = require("microtime");

    var mt1 = microtime.now();

    engine.eval(args[0]);

    var mt2 = microtime.now()

    var sub = mt2 - mt1;

console.log(sub);

    return sub;
  }
}
