# RobCards usage documentation

```diff
- This documentation is under construction!


- It will probably remain incomplete and erroneous until
- the application itself is in a more developed state.

- Right now things can and will change, rapidly.
- It will probably become a lot more wordy and complicated,
- before it gets trimmed down and revised.
```

## What's the point of RobCards?

RobCards allows a designer to design cards, tokens, player boards, play fields, cut-outs, whatever 2D design a board or card game designer might want to create. It is primarily geared towards cards, but there's nothing stopping you from getting creative.

Designs are created using an understandable config file format (actually just [Lua](https://www.lua.org/) [tables](https://www.lua.org/pil/2.5.html)), no programming is required.

Designs are created by defining a general Layout to be used by an archetype of cards. After this, the designer can then rapidly create as many card variations as they want using those layouts, and because the template is defined separately in a single place, every card that uses the same layout will be consistent, even if the content (text, card art, icons, etc) changes.

Once you have some card designs ready to go, you can launch the RobCards application to graphically visualize and browse among all your defined cards. Finally, you can export all the cards individually to disk as PNG images, in pixel-perfect detail, ready for printing at home, using in a game engine, or to get printed on real card stock!

RobCards should support very large images, although it is somewhat dependant on your hardware, due to the technique used for rendering cards. You can pretty safely assume that almost all systems will be able to render 2048x2048 cards, and many systems will be able to render cards up to 16384x16384 (that's a whopping 268 Megapixels). For gory details on supported resolutions per GPU, see [this list](https://feedback.wildfiregames.com/report/opengl/feature/GL_MAX_TEXTURE_SIZE).

**Move on to the [Tutorial](tutorial.md) to get started and see how this all works**