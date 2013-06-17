var cmo = cmo || {};
cmo.utils = cmo.utils || (function() {
  var util_obj = function util() {};

  $.extend(util_obj.prototype, {
    inherit: function(C, Base) {
      var F = function() {};
      F.prototype = Base.prototype;
      C.prototype = new F();
      C._super = Base.prototype;
      C.prototype.constructor = C;
      return C;
    }
  });

  return {
    Util : util_obj
  };
})();