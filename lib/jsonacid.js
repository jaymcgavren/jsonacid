//Copyright (c) 2010 Jay McGavren.
//
//Permission is hereby granted, free of charge, to any person obtaining
//a copy of this software and associated documentation files (the
//"Software"), to deal in the Software without restriction, including
//without limitation the rights to use, copy, modify, merge, publish,
//distribute, sublicense, and/or sell copies of the Software, and to
//permit persons to whom the Software is furnished to do so, subject to
//the following conditions:
//
//The above copyright notice and this permission notice shall be
//included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


//The parent class for all other Factories.
//Should not normally be instantiated directly.
//Takes a hash with these keys and defaults:
//  source_factories : []
function Factory() {

  var options = arguments[0] == null ? {} : arguments[0];
  
  //An array of factories to be queried by get_unit and have their return values averaged.
  this.sourceFactories = options['source_factories'] || [];
  
  //Calls getUnit(key) on each source factory and averages results.
  this.getUnit = function (key) {
    if (this.sourceFactories.length == 0) return 0.0;
    var sum = 0.0;
    for (var i = 0; i < this.sourceFactories.length; i++) {
      sum += this.sourceFactories[i].getUnit(key);
    }
    return sum / this.sourceFactories.length;
  }

  //Calls getUnit() with key to get value between 0.0 and 1.0, then converts that value to be between given minimum and maximum.
  //The following argument combinations are acceptable:
  //get(key): Uses maximum of 1.0, minimum of 0.0
  //get(key, max): Uses specified maximum, minimum of 0.0 (or maximum - 1.0 if maximum is <= 0.0)
  //get(key, min, max): Uses specified minimum and maximum.
  this.get = function (key) {
    if (arguments.length == 3) {min = arguments[1]; max = arguments[2];}
    else if (arguments.length == 2) {max = arguments[1]; min = max > 0.0 ? 0.0 : max - 1.0;}
    else if (arguments.length == 1) {min = 0.0; max = 1.0;}
    return (this.getUnit(key) * (max - min)) + min;
  }
  
  //Returns true if this.getUnit(key) returns greater than 0.5.
  this.boolean = function (key) {
    return this.getUnit(key) >= 0.5;
  }
  
  //Calls this.getUnit with key to get value between 0.0 and 1.0, then converts that value to an index within the given list of choices.
  //Choices can be an array or an argument list of arbitrary size.
  this.choose = function (key) {
    if (arguments[1] instanceof Array) {choices = arguments[1];}
    else {
      choices = [];
      for (var i = 1; i <= arguments.length - 1; i++) {choices.push(arguments[i]);}
    }
    var index = Math.floor(this.getUnit(key) * choices.length);
    if (index > choices.length - 1) {index = choices.length - 1;}
    return choices[index];
  }
  
}


//Combines values from source factories together in the prescribed manner.
//Takes a hash with all keys supported by Factory, plus these keys and defaults:
//  operation => OPERATION.add
//  constrainMode => CONSTRAIN_MODE.wrap
function CombinationFactory() {
  
  var options = arguments[0] || {};
  
  //The operation getUnit() will perform to combine source factory values.
  this.operation = options['operation'] || CombinationFactory.OPERATION.add;
  //The method getUnit() will use to constrain values between 0 and 1.
  this.constrainMode = options['constrainMode'] || CombinationFactory.CONSTRAIN_MODE.wrap;
  
  this.combine = function (key) {
    var initialValue = this.sourceFactories[0].getUnit(key);
    switch (this.operation) {
      case CombinationFactory.OPERATION.add:
        var sum = initialValue;
        for (var i = 1; i < this.sourceFactories.length; i++) {
          sum += this.sourceFactories[i].getUnit(key);
        }
        return sum;
      case CombinationFactory.OPERATION.subtract:
        var sum = initialValue;
        for (var i = 1; i < this.sourceFactories.length; i++) {
          sum -= this.sourceFactories[i].getUnit(key);
        }
        return sum;
      case CombinationFactory.OPERATION.multiply:
        var product = initialValue;
        for (var i = 1; i < this.sourceFactories.length; i++) {
          product *= this.sourceFactories[i].getUnit(key);
        }
        return product;
      case CombinationFactory.OPERATION.divide:
        var product = initialValue;
        for (var i = 1; i < this.sourceFactories.length; i++) {
          product /= this.sourceFactories[i].getUnit(key);
        }
        return product;
      default:
        throw "invalid operation - must be 'add', 'multiply', 'subtract', or 'divide'";
    }
  }
  
  this.constrain = function (value) {
    switch (this.constrainMode) {
      case CombinationFactory.CONSTRAIN_MODE.constrain:
        if (value > 1.0) {return 1.0;}
        else if (value < 0.0) {return 0.0;}
        else {return value;}
        break;
      case CombinationFactory.CONSTRAIN_MODE.wrap:
        var remainder = value % 1.0;
        return remainder >= 0.0 ? remainder : 1.0 + remainder;
      default:
        throw "invalid constrain mode - must be 'constrain' or 'wrap'"
    }
  }
  
  //Queries all sourceFactories with given key and combines their return values with the set operation.
  //Values will be constrained between 0 and 1 with the set constrainMode.
  this.getUnit = function (key) {
    var combinedValue = this.combine(key);
    return this.constrain(combinedValue);
  }
  
}
CombinationFactory.prototype = new Factory();
//'add' causes getUnit() value of all sourceFactories to be added together.
//'subtract' takes the getUnit() value of the first of the sourceFactories and subtracts the getUnit() value of all subsequent ones.
//'multiply' causes getUnit() value of all sourceFactories to be multiplied.
//'divide' takes the getUnit() value of the first of the sourceFactories and divides the result by the getUnit() value of all subsequent ones.
CombinationFactory.OPERATION = {add: 'add', subtract: 'subtract', multiply: 'multiply', divide: 'divide'};
//'constrain' causes getUnit() values above 1 to be truncated at 1 and values below 0 to be truncated at 0.
//'wrap' causes getUnit() values above 1 to wrap to 0 and values below 0 to wrap to 1.
CombinationFactory.CONSTRAIN_MODE = {constrain: 'constrain', wrap: 'wrap'};


//A factory that returns a preset value for all keys.
//Takes a hash with all keys supported by Factory, plus these keys and defaults:
//  value => 0.0
function ConstantFactory() {
  
  var options = arguments[0] || {};
  
  //A value between 0 and 1 that getUnit() will return.
  this.value = options['value'] || 0.0;
  
  //Returns assigned value.
  this.getUnit = function (key) {
    return this.value;
  }

}
ConstantFactory.prototype = new Factory();


function FlashFactory() {
  
  var options = arguments[0] || {};
  
  //The number of times to return a value before switching.
  this.interval = options['interval'] || 3;
  this.counters = {};
  this.values = {};
  
  //If key is over threshold, flip to other value and reset counter.
  this.getUnit = function (key) {
    if (this.counters[key] == null) this.counters[key] = 0;
    if (this.values[key] == null) this.values[key] = 1.0;
    if (this.counters[key] >= this.interval) {
      this.values[key] = (this.values[key] == 1.0 ? 0.0 : 1.0);
      this.counters[key] = 0;
    }
    this.counters[key] += 1;
    return this.values[key];
  }

}
FlashFactory.prototype = new Factory();


//Loops from the minimum value to the maximum and around again.
//Takes a hash with all keys supported by Factory, plus these keys and defaults:
//  :interval => 0.01
function LoopFactory() {
  
  var options = arguments[0] || {};
  
  //An amount between 0 and 1 to increment counters by.
  this.interval = options['interval'] || 0.01;
  
  var counters = {};

  //Increment counter for key, looping it around to opposite side if it exits boundary.
  this.getUnit = function (key) {
    if (counters[key] == null) {counters[key] = 0;}
    counters[key] += this.interval;
    if (counters[key] > 1) {counters[key] = counters[key] - 1.0;}
    else if (counters[key] < 0) {counters[key] = counters[key] + 1.0;}
    return counters[key];
  }
}
LoopFactory.prototype = new Factory();


// //Allows values to be assigned from an external source, storing values over time.
// function QueueFactory() {
// 
//   var queueValues = {};
//   var keyAssignments = {};
//   var largestSeenValues = {};
//   var smallestSeenValues = {};
// 
//   //Retrieves the next stored value for the given key.
//   //The key that values are pulled from will not necessarily be the same as that passed to put() - value queue keys are assigned to getUnit() keys at random.
//   //Retrieve average from source factories if no queued values are available, or zero if no source factories are assigned.
//   this.getUnit = function (key) {
//     currentKey = assignedKey(key)
//     if (queueValues[currentKey] != null && queueValues[currentKey].length > 0) {
//       return scale(currentKey, queueValues[currentKey].shift) || super(currentKey) || 0.0;
//     } else {
//       return super(currentKey) || 0.0;
//     }
//   }
// 
//   //Store a value for the given key.
//   //Values will be scaled to the range 0 to 1 - the largest value yet seen will be scaled to 1.0, the smallest yet seen to 0.0.
//   this.put = function (key, value) {
//     value = value.toF
//     queueValues[key] ||= []
//     queueValues[key] << value
//     smallestSeenValues[key] ||= 0.0
//     if largestSeenValues[key] == nil or smallestSeenValues[key] > largestSeenValues[key]
//       largestSeenValues[key] = smallestSeenValues[key] + 1.0
//     end
//     smallestSeenValues[key] = value if value < smallestSeenValues[key]
//     largestSeenValues[key] = value if value > largestSeenValues[key]
//   }
//   
//   //Clears all stored queue values for all keys.
//   this.clearQueueValues = function () {
//     queueValues = {}
//   }
//   
//   //Clear all value queue key assignments.
//   this.clearAssignedKeys = function () {
//     this.assignedKeys = {}
//   }
//   
//   private
//   
//     this.assignedKey = function (key) {
//       return keyAssignments[key] if keyAssignments[key]
//       keyPool = queueValues.keys - keyAssignments.values
//       keyAssignments[key] = keyPool[rand(keyPool.length)]
//       keyAssignments[key]
//     }
//     
//     //Scales a value between the largest and smallest values seen for a key.
//     //Returns a value in the range 0 to 1.
//     this.scale = function (key, value) {
//       (value - smallestSeenValues[key]) / (largestSeenValues[key] - smallestSeenValues[key])
//     }
//   
// }
// QueueFactory.prototype = new Factory();


//Returns random numbers between the minimum and the maximum.
function RandomFactory() {

  //Returns a random value between 0 and 1.
  this.getUnit = function (key) {
    return Math.random();
  }

}
RandomFactory.prototype = new Factory();


//Each subsequent call subtracts or adds a random amount to a given key's value.
//Takes a hash with all keys supported by Factory, plus these keys and defaults:
//  :interval => 0.001
function RandomWalkFactory() {

  var options = arguments[0] || {};

  //The maximum amount to change values by.
  this.interval = options['interval'] || 0.001;

  this.startValue = 0.0;
  this.values = {};
  
  //Add a random amount ranging between interval and -1 * interval to the given key's value and return the new value.
  this.getUnit = function (key) {
    if (this.values[key] == null) {this.values[key] = Math.random();}
    this.values[key] += Math.random() * (2 * this.interval) - this.interval;
    if (this.values[key] > 1.0) {this.values[key] = 1.0;}
    else if (this.values[key] < 0.0) {this.values[key] = 0.0;}
    return this.values[key];
  }

}
RandomWalkFactory.prototype = new Factory();


//Rounds values from a source factory, useful for clustering values into groups.
//Takes a hash with all keys supported by Factory, plus these keys and defaults:
//  :nearest => 0.1
function RoundingFactory() {
  
  var options = arguments[0] || {};
  
  //Source values will be rounded to the nearest multiple of this value.
  this.nearest = options['nearest'] || 0.1;
  
}
RoundingFactory.prototype = new Factory();
//Get values from source factories and round result to assigned nearest multiple. 
RoundingFactory.prototype.getUnit = function (key) {
  var value = Factory.getUnit.call(this);
  var multipleOf = this.nearest;
print("value: " + value);
print("multipleOf: " + multipleOf);
  var modulus = value % multipleOf;
  var quotient = value / multipleOf - modulus;
  if (modulus / multipleOf < 0.5) {
    return multipleOf * quotient;
  }
  else {
    var result = multipleOf * (quotient + 1);
    return result > 1.0 ? 1.0 : result;
  }
}


//Produces a "wave" pattern.
//Takes a hash with all keys supported by Factory, plus these keys and defaults:
//  :interval => 0.1
function SineFactory() {
  
  var options = arguments[0] || {};
  
  //Counters used to calculate sine values will be incremented by this amount with each query.
  this.interval = options['interval'] || 0.1;

  var counters = {};
  
  //Increment counter for key and get its sine, then scale it between 0 and 1.
  this.getUnit = function (key) {
    if (counters[key] == null) {counters[key] = 0;}
    counters[key] += this.interval;
    return (Math.sin(counters[key]) + 1) / 2
  }
  
}
SineFactory.prototype = new Factory();


//Returns the minimum or the maximum at random (influenced by the given odds).
//Takes a hash with all keys supported by Factory, plus these keys and defaults:
//  :odds => 0.1
function SkipFactory() {
  
  var options = arguments[0] || {};
  
  //The percentage odds that the factory will return 0 instead of 1.
  this.odds = options['odds'] || 0.1;
  
  //If a random number between 0 and 1 is less than the assigned odds value, will return 0 (a "skip").
  //Otherwise returns 1.
  this.getUnit = function (key) {
    return Math.random() < this.odds ? 0.0 : 1.0;
  }

}
SkipFactory.prototype = new Factory();


function WeightedFactory() {

  var options = arguments[0] || {};

  var weights = {};
  var weightId = 0;
  //Set the weight the factory will be given in averaging values.  Default is 1.0.
  this.setWeight = function(factory, weight) {
    factory.weightId = weightId++;
    weights[factory.weightId] = weight;
  }

  //Calls #getUnit(key) on each source factory and multiples value by weight.
  //Then divides total of values by total weight to get weighted average.
  this.getUnit = function (key) {
    if (this.sourceFactories.length == 0) {return 0.0;}
    var sum = 0.0;
    var totalWeight = 0.0;
    for (var i = 0; i < this.sourceFactories.length; i++) {
      var factory = this.sourceFactories[i];
      var weight = weights[factory.weightId] || 1.0;
      sum += factory.getUnit(key) * weight;
      totalWeight += weight;
    }
    if (totalWeight == 0) {return 0.0;}
    return sum / totalWeight;
  }
  
}
WeightedFactory.prototype = new Factory();
