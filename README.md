bacon.gsap
==========

GreenSock Animation Platform bindings for [Bacon.js](https://github.com/baconjs/bacon.js)

Basics
======

Here goes description for methods =).

`Tween` states for `TweenMax` or `TweenLite` either, depending on what library you use in your project.

Tween.EventStreamTo
-------------------
Creates a new EventStream using `Tween.to` method so that it produces `Next` events for `onUpdate`, and `End` event for `onComplete` callbacks respectively.

Example:

```js
Tween.EventStreamTo($("img"), 1, {css:{opacity:0.5}}).log()
```

Tween.EventStreamFrom
---------------------
Creates a new EventStream using `Tween.from` method so that it produces `Next` events for `onUpdate`, and `End` event for `onComplete` callbacks respectively.

Example:

```js
Tween.EventStreamFrom($("img"), 1, {css:{opacity:0.5}}).log()
```


Tween.prototype.asEventStream
-----------------------------

Extends Tween prototype so that you can convert existing tween into new `EventStream`, and then subscribe for various events like `update`, `complete`, `reverse`, `reverseComplete` etc.
*Temporarily, tweens become paused when this method is invoked, you need to start them manually*

Example:

```js
var tween = Tween.to($("img"), 1, {css:{opacity:0.5}})

tween.play().asEventStream("update").log()
```