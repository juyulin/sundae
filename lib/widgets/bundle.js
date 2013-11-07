// Generated by CoffeeScript 1.6.3
(function() {
  var Bundle, bundle,
    __slice = [].slice;

  Bundle = (function() {
    var Mixed, _checkType;

    Mixed = function() {};

    _checkType = function(val, type) {
      switch (type) {
        case Object:
        case Array:
        case Buffer:
        case Date:
          return val instanceof type;
        case String:
          return typeof val === 'string';
        case Number:
          return tyepof(val === 'number');
        case Boolean:
          return typeof val === 'boolean';
        case Mixed:
          return true;
        default:
          return false;
      }
    };

    Bundle.prototype.schema = {
      req: Object,
      res: Object,
      ctrl: String,
      func: String,
      data: Mixed
    };

    function Bundle(type, weeds) {
      var parseMethod;
      this.attrs = {};
      parseMethod = "parse" + (type[0].toUpperCase()) + type.slice(1);
      if (typeof this[parseMethod] === 'function') {
        this[parseMethod](weeds);
      }
    }

    Bundle.prototype.parseRest = function(weeds) {};

    Bundle.prototype.parseSocket = function(weeds) {};

    Bundle.prototype.set = function(key, val) {
      if ((this.schema[key] != null) && _checkType(val, this.schema[key])) {
        this.attrs[key] = val;
      }
      return this;
    };

    Bundle.prototype.get = function(key) {
      return this.attrs[key];
    };

    Bundle.prototype.toJSON = function() {
      return this.attrs;
    };

    return Bundle;

  })();

  bundle = function() {
    var type, weeds;
    type = arguments[0], weeds = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    if (type == null) {
      type = 'rest';
    }
    return new Bundle(type, weeds);
  };

  module.exports = bundle;

}).call(this);