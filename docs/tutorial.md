# Tutorial

RobCards does not require the designer to write any code. *However*, due to the fact that the Layout and Card config files themselves are actually Lua source code, basic programming can be used if the designer wants to get frisky (arithmetic operators, etc), however generally speaking you should just follow the examples and define Layouts and Cards that way. If you start doing complicated stuff, you are on your own!

I will be referring to things as *cards* throughout the tutorial, however as mentioned on the front page, you could extend your imagination and create almost anything 2D using RobCards.


# Step 1: Card Layouts

The very first step to get started, is to create a Card Layout. Card Layouts are essentially templates for how a certain archetype of card should look.

Card Layouts define a couple of important things:
* The overall size and shape for the card type
* Any background image texture and / or color
* Various solid or outline shapes (boxes, lines)
* Locations and styles for strings of text, single digits, and entire paragraphs
* Locations and sizes of individual pieces of art, such as card art, icons, decorations, etc

It's important to understand that Layouts only define WHERE and HOW these things will be rendered. The Layout does **not** define exactly WHAT will be rendered... For example, the Layout may only define that there will be a string of text called "name" at the top of the card. The Layout will define the color and size and position of this text. However, the actual text is defined by the card variants themselves later.

Layouts can be very simple or very complex, there is no practical limit. However, for most realistic use cases, creating the Layout is actually the hardest part, and can take quite some time. This time investment should hopefully be worth is, as once you've created the Layout, defining cards that use this layout takes literally just seconds, and you can create as many as you want.

Of course, creating the art assets for these card variants (card art, icons, etc) will also take time, but that is outside the scope of RobCards itself.




## Practical Example of a Card Layout

< *to be continued* >