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

< *BEWARE COPY PASTA BELOW* >


Layouts are defined as such:

Each layout has a name. This name is simply the name of the table.
Inside this layout, are some sub-tables. These table names are CaSe SeNsItIvE!

`body`
Simply describes the exact size of the card, as well as a background color or image, if any (optional).
Setting an image AND a color, will tint the image. To avoid tint, just omit the color, or set it to white (1,1,1,1).
The main purpose of the body is to simply define the "container" for the card type.
In a future version, the body will let you define the cutout shape for a card type.
This would let you make, for example, rounded corners. Or any other shape. Not yet, because stencil code makes my head hurt

`shapes`
Describes the layout of rectangles, lines, circles, or polygons, or images that you want to draw.
Images will be the exact same for every variant of the card, so this is NOT for individual card art.
Shapes can choose between two styles: "fill" or "outline".
Shape are rendered in order from top to bottom.
Shape names are, for now, ignored, but you can use them to keep track of what's what.
Legal shape types are: "rectangle", "circle", "line" and "polygon".


`text`
Describes the layout (BUT NOT THE DATA) for the text you want to show on the card,
including position, color, size, alignment (left, right, center).
Eventually support different fonts for different texts, but not right now.


`art`
Describes the location and size of art images. This is where you would define things
such as unique center card art, or perhaps icons for damage types, or small art details in general.
All art is drawn as rectangles. If you want more complex shapes, use transparency in your art.
Art name attributes are only really used for placeholders if your art file is missing or broken.
Width and Height for art is optional; if omitted, the image will be drawn straight to the screen.
If you define width and height, the image will be stretched to fit. Aspect Ratio will not be maintained.
Scaling an image may lead to blur or aliasing.
Highly recommend you create the source art in the correct dimensions instead, and draw them unscaled.


-- Notes --
About colors:
The format for color attributes is {R,G,B,A}, from 0 to 1, and the last one, Alpha, is optional.

About positions:
Shape and image sizes and positions are clamped to the size of the card body, as much as possible.
That means if you try to place a shape or image or text outside the body, it will clamp inside.
Likewise if you try to create a shape that is too wide, it will clamp to fit inside the body.
If this clamping is unnecessary, just talk to me, I can change how it works and remove the clamping,
allowing you to create horrible glitch monsters to your hearts content!


There is a special _default tag for `text` and `shapes`, that defines some default values.
This can be used if you want to, for example, default to a custom font, instead of
the Love2D default font. Or, if you want all shapes to default to a certain color, etc.