# pico-a11y-template
Accessible HTML template for pico 8 games, with a live read out for screen readers.

## Local Test
You can test this locally by going to
[https://jrjurman.com/pico-a11y-template/a11y_page.html](https://jrjurman.com/pico-a11y-template/a11y_page.html).

## How To Use
Include the following code in your pico 8 game
```lua
gpio_addr = 0x5f80
function aria(text)
  for i = 0, #text do
    local char = ord(text, i)
    local addr = gpio_addr + i
    poke(addr, char)
  end
  print(text)
end
```

Then, anywhere in your game where you would like to have screen-readable text,
call the `aria` function.

```lua
aria("we hope you enjoy this game")
```

You'll need to export your game for HTML
```
export your_game_name.html
```

Then, update the included `a11y_page.html` template to point to the generated
game JS file (this is set on line 14 of the HTML template). This path will need
 to point either relatively or directly to where your carts are saved (you can
 run `FOLDER` in pico 8 to find this path).
```js
window.cart_source = "/Users/jrjurman/Library/Application Support/pico-8/carts/aria_test.js"
```

## Changes Made
The provided `a11y_page.html` template is a modified version of the default
template that is generated when running `export`. Below is a list of changes
made to the template.

### Aria Readout
The most significant change included is the addition of an `aria-live` region
that reads the output of GPIO addresses. This is done so that screen readers
can read what is happening in the game.

### Image Labels
The default template includes many images with no aria labels, and generates a
lot of audible noise when using a screen reader. I've added `aria-label` and
`aria-hidden` attributes where it feels most appropriate.

### Source Location
By default, the custom properties of the game, like the js source path, and
image background, are defined fairly deep in the page. This has been moved to
the top, so that it is easy for developers to set and update these properties.

## Issues & Improvements
I'm admittedly very new to accessibility, and even more so when it comes to
game dev, so please make issues and feel free to contribute with PRs if there
are any improvements that can be made here!
