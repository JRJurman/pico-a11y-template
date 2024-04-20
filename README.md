# pico-a11y-template

<img src="./logo.png" width="200px" alt="pico-a11y-template logo, minimalistic icon of a speech bubble with sound waves inside">

Accessible HTML template for pico 8 games, with a live read out for screen readers.

https://github.com/JRJurman/pico-a11y-template/assets/326557/6a5cc45e-f142-4b4d-a0dc-cd9c956b64c0

## Local Test
You can test this locally by going to
[https://jrjurman.com/pico-a11y-template/a11y_page.html](https://jrjurman.com/pico-a11y-template/a11y_page.html).

Alternatively, you can clone this repo, and open the `a11y_page.html` with your browser.

## How To Use
Copy the code from `a11y_code.lua` or `a11y_code.min.lua` into your project. That will give you access to the API, and when loaded in the `a11y_page.html`, will show text to screen readers.

## PICO-8 API

### `set_sr_text(text)`
`set_sr_text` will tell PICO-8 to load the `text` in a way that screen readers will announce the text.
The text can be any length. You can preview the results if you have a terminal open (it uses the `printh` function to write out to the terminal).

You only need to call this function once, it is recommended to do this on a user taking an action, or something happening in the game (although, do not make assumptions about how slow or fast the user's screen reader is).

```lua
if (btnp(🅾️)) then
    counter = 0
    set_sr_text("counter reset")
end
```

### `update_sr()` and `handle_pause_sr()`
`update_sr` and `handle_pause_sr` are functions to update the screen reader as part of the update function.

`update_sr` will handle presenting multiple pages of text (which get calculated automatically).

`handle_pause_sr` will allow the page to write to the screen reader when the pause menu launches. While the menu itself is not accessible, this allows us to write a custom message that explains that a menu has been launched, and how to leave the menu.

Both of these functions should be included at the end of the `_update` function.

```lua
function _update()

  -- your game logic ...

  update_sr()
  handle_pause_sr()
end
```

## HTML Changes Made
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

## Linting and Minification

This project uses [shrinko8](https://github.com/thisismypassport/shrinko8) for linting and minification.
To use this, clone the project, and from that directory run the following commands:

For linting:
```sh
python shrinko8.py ../pico-a11y/a11y_code.lua --lint
```

For minification:
```sh
python shrinko8.py ../pico-a11y/a11y_code.lua ../pico-a11y/a11y_code.min.lua --minify-safe-only --no-minify-rename
```

Then delete all the code before `a11y_start=24448`.
