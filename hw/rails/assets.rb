# organizing CSS
=begin
within app/assets/stylesheets, 4 elements:
    application.sass.scss manifest file to bundle all CSS
    mixins/ folder for Sass mixins
        _media.scss - define breakpoints of media queries
    config/ folder for variables and global styles
    components/ folder for layout components => independent pieces of the web page, should not be concerned with how they are laid out, only their style
        # avoid outer margins for components
    layouts/ folder for layouts => concerns positioning, margins, centering, etc.

use mobile-first approach
=end