init = (Bacon, $) ->
  globals = window.GreenSockGlobals || window
  Tween = globals.TweenMax || globals.TweenLite

  _capitalize = (s) -> s[0...1].toUpperCase() + s[1..]

  _addCallback = (type, func=(->), obj, vars) ->
    if typeof obj isnt "object"
      obj = [obj]
    vars[type] = obj.each || obj.forEach
    vars[type + "Scope"] = obj
    vars[type + "Params"] = [func]
    return


  makeEventStream = (obj, interval, vars, direction="to", eventTransformer = Bacon._.id) ->
    new Bacon.EventStream (sink) ->
      handleUpdate = (args...) -> 
        sink(new Bacon.Next(eventTransformer args...))  
        return
      handleComplete = -> 
        sink(new Bacon.End())
        return
      unbind = -> 
        Tween.killTweensOf(obj)
        return
      
      _addCallback("onUpdate", handleUpdate, obj, vars)
      _addCallback("onComplete", handleComplete, obj, vars)
      Tween[direction](obj, interval, vars)
      unbind

  Tween.EventStreamTo = (obj, interval, vars, eventTransformer = Bacon._.id) ->
    makeEventStream(obj, interval, vars, "to" ,eventTransformer)
  Tween.EventStreamFrom = (obj, interval, vars, eventTransformer = Bacon._.id) ->
    makeEventStream(obj, interval, vars, "from", eventTransformer)


  Tween::asEventStream = (eventName, eventTransformer = Bacon._.id) ->
    @pause()
    new Bacon.EventStream (sink) =>
      handler = (args...) ->
        reply = sink(new Bacon.Next(eventTransformer args...))
        if reply == Bacon.noMore
          unbind()

      unbind = => Tween.killTweensOf(@target)
      
      _addCallback(
        "on" + _capitalize(eventName),
        handler,
        @target,
        @vars
      )
      unbind

if module?
  Bacon = require "baconjs"
  $ = require "jquery"
  module.exports = init Bacon, $
else
  if typeof define == "function" and define.amd
    define ["bacon", "jquery"], init
  else
    init @Bacon, @$