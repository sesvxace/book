#--
# Window_Book v3.0 by Enelvon
# =============================================================================
#
# Changelog
# -----------------------------------------------------------------------------
# 11.18.2012: v1.0 - Script written.
# 11.19.2012: v1.1 - Fixed a bug with escape characters where only the first
#                    one would be processed for each word.
# 11.19.2012: v1.2 - Fixed a second escape character bug where they were not
#                    being applied correctly.
# 11.19.2012: v1.3 - Added in [Scene_Book] to allow simple books to be
#                    displayed a little more easily.
# 11.20.2012: v1.4 - Modified [write_page_text] to be able to take parameters.
# 04.17.2014: v2.0 - Made code more efficient and cleaned it up a little. Also
#                    added a few parameters to Window_Book#contents_height and
#                    Window_Book#write_page_text to allow the use of methods to
#                    dynamically determine the length of a given line, which
#                    greatly improves support for e.g. images.
# 05.28.2014: v3.0 - Added column support, further improved efficiency of the
#                    script.
#
# Summary
# -----------------------------------------------------------------------------
# This script is essentially a scripter's resource, but it has been optimized
# for use by those with little-to-no experience in scripting. It provides a
# parent class for multi-page windows, with a focus on those used to display
# information (though it is also possible, with some additions, to include pages
# with selectable areas). Its write_page_text method draws text in a similar
# manner to the draw_text_ex method, allowing you to use any control character
# that you would normally use in game text (with the exception of those that
# control timing). Further down, I have included a tutorial on creating a basic
# guide to a game's controls as an example of a simple use of the script. By
# reading the tutorial, a non-scripter can learn how to easily create and call a
# book window. I had a non-scripter friend try it out, and within ten minutes
# they had written a functional battle guide. Try it out and see what you can
# make!
#
# Compatibility Information
# -----------------------------------------------------------------------------
# Required Scripts: None
# Known Incompatibilities: None, and as this is a new class (and thus contains
#     no direct redefinitions of the base scripts), it should never have any. It
#     does contain a few new methods for existing classes, but nothing that is
#     likely to cause problems. The only potential issues that this script may
#     encounter would come from other scripts redefining methods in Window_Base,
#     but with the exception of bugfixes that is fairly bad practice in the
#     first place. Everything else is almost guaranteed to be user error.
#
# Overwritten Methods
# -----------------------------------------------------------------------------
# None
#
# Aliased Methods
# -----------------------------------------------------------------------------
# None
#
# New Methods
# -----------------------------------------------------------------------------
# module SceneManager
#   - push_to_stack
#
# class Game_Interpreter
#   - show_book
#
# class Window_Book - NEW
#   - initialize
#   - update
#   - dispose
#   - max_pages
#   - scroll_speed
#   - dy
#   - draw_text_ex
#   - refresh
#   - contents_height
#   - split_for_height
#   - calc_height
#   - method_missing
#   - text_width
#   - write_page_text
#   - split_text
#   - write_text
#   - arrow_bitmap
#   - sx
#   - scrolldata
#   - draw_scroll
#   - process_cursor_move
#
# class Scene_Book - NEW
#   - set_book
#   - update
#
# Installation
# -----------------------------------------------------------------------------
#   Place below Materials and above all other custom scripts, or
#   with the Window_* classes if you want to keep things organized.
#
# Instructions
# -----------------------------------------------------------------------------
#   This script serves as a resource to create multi-page windows. I will use
#   this space to give an example of how to make and display a simple book that
#   contains the controls for the game.
#
#   The first thing that we have to do is create a new window class. Let's call
#   it Guide.
#
#     class Guide < Window_Book
#
#   Okay, so we've opened our class. Now we need to define our initialize
#   method. It will contain our definition of @pagetext.
#
#     class Guide < Window_Book
#
#       def initialize
#         @pagetext = {
#           2 => ["In this mini guide you will be given a basic introduction to playing the game. I hope it proves informative."],
#           3 => ["\\c[16]Button Controls:", "", "\\c[16]Movement:",
#                 "Use the direction keys to move your character on the map, and your cursor when in menus. Hold down Shift to run. When you are in a character-related menu, you can use Q, W, PgDn, and PgUp to move between characters.",
#                 "", "\\c[16]Opening the Menu:",
#                 "Press X, 0 on the number pad, or Esc to open the menu when you are on the map.",
#                 "", "\\c[16]Selection:",
#                 "Press Z, Space or Enter to interact with characters and items on the map, or to make a selection when in a menu.",
#                 "", "\\c[16]Cancelling:",
#                 "Press X, 0 on the number pad, or Esc to go back in a menu or cancel a choice."],
#           4 => ["\\c[16]File Operations:", "", "\\c[16]Saving Your Game:",
#                 "Select \\c[16]Save \\c[0]from the in-game menu and choose a slot in which to save your game.",
#                 "", "\\c[16]Loading Your Game:",
#                 "If you are currently in the game, return to the title screen. Select \\c[16]Load Game \\c[0]and choose the slot you want to load."],
#           5 => ["Have fun, and good luck!"]
#         }
#         super
#       end
#
#   Sorry about how long those text lines are, but going down to a new line and
#   having indentations causes the formatting to be hideous when the text is
#   drawn. Anyway, as you can see, we're able to use control characters from
#   the game's message windows in our text. Always make sure to use two (rather
#   than one) backslashes for the control character, and that it is attached to
#   the first word/character that it is intended to affect. I skipped page 1
#   because we'll do that a little differently - we're going to center the text
#   for it and place it near the top of the page, as it's the cover of the
#   book.
#
#       def initialize
#         @pagetext = {
#           2 => ["In this mini guide you will be given a basic introduction to playing the game. I hope it proves informative."],
#           3 => ["\\c[16]Button Controls:", "", "\\c[16]Movement:",
#                 "Use the direction keys to move your character on the map, and your cursor when in menus. Hold down Shift to run. When you are in a character-related menu, you can use Q, W, PgDn, and PgUp to move between characters.",
#                 "", "\\c[16]Opening the Menu:",
#                 "Press X, 0 on the number pad, or Esc to open the menu when you are on the map.",
#                 "", "\\c[16]Selection:",
#                 "Press Z, Space or Enter to interact with characters and items on the map, or to make a selection when in a menu.",
#                 "", "\\c[16]Cancelling:",
#                 "Press X, 0 on the number pad, or Esc to go back in a menu or cancel a choice."],
#           4 => ["\\c[16]File Operations:", "", "\\c[16]Saving Your Game:",
#                 "Select \\c[16]Save \\c[0]from the in-game menu and choose a slot in which to save your game.",
#                 "", "\\c[16]Loading Your Game:",
#                 "If you are currently in the game, return to the title screen. Select \\c[16]Load Game \\c[0]and choose the slot you want to load."],
#           5 => ["Have fun, and good luck!"]
#         }
#         super
#       end
#
#       def draw_page1
#         x = (contents_width - text_size("Game Guide").width) / 2
#         y = (contents_height - line_height) / 4
#         draw_text_ex(x, y, "\\c[14]Game Guide")
#       end
#
#   Here we find the center of the book page horizontally and 1/4 of the page
#   vertically, then draw the text there. Now we have five pages in our book
#   (four in the @pagetext hash and one defined explicitly), so the next thing
#   we should do is define max_pages.
#
#       def initialize
#         @pagetext = {
#           2 => ["In this mini guide you will be given a basic introduction to playing the game. I hope it proves informative."],
#           3 => ["\\c[16]Button Controls:", "", "\\c[16]Movement:",
#                 "Use the direction keys to move your character on the map, and your cursor when in menus. Hold down Shift to run. When you are in a character-related menu, you can use Q, W, PgDn, and PgUp to move between characters.",
#                 "", "\\c[16]Opening the Menu:",
#                 "Press X, 0 on the number pad, or Esc to open the menu when you are on the map.",
#                 "", "\\c[16]Selection:",
#                 "Press Z, Space or Enter to interact with characters and items on the map, or to make a selection when in a menu.",
#                 "", "\\c[16]Cancelling:",
#                 "Press X, 0 on the number pad, or Esc to go back in a menu or cancel a choice."],
#           4 => ["\\c[16]File Operations:", "", "\\c[16]Saving Your Game:",
#                 "Select \\c[16]Save \\c[0]from the in-game menu and choose a slot in which to save your game.",
#                 "", "\\c[16]Loading Your Game:",
#                 "If you are currently in the game, return to the title screen. Select \\c[16]Load Game \\c[0]and choose the slot you want to load."],
#           5 => ["Have fun, and good luck!"]
#         }
#         super
#       end
#
#       def draw_page1
#         x = (contents_width - text_size("Game Guide").width) / 2
#         y = (contents_height - line_height) / 4
#         draw_text_ex(x, y, "\\c[14]Game Guide")
#       end
#
#       def max_pages; 5; end
#     end
#
#   There we go! As you can see, I ended the Guide class after defining
#   max_pages. Why? Because it's done! We created a five-page book in 20 lines,
#   and 7 of those were used to define the contents of the pages! Isn't that
#   easy?
#
#   We're not quite done, though. We have one more task ahead of us: calling
#   the window for display. Prior to version 1.3, this had to be done by
#   creating a new class and calling that. 1.3 introduced the Scene_Book class,
#   which simplified this for basic users - advanced books will still need
#   their own classes if they're going to be used for anything but simple
#   reading. To call the default book scene with the guide, put this in an
#   event:
#
#     show_book(Guide, Scene_Map)
#
#   That will display the book, as I've added the show_book command to the Game
#   Interpreter class. You could also use this:
#
#     SceneManager.goto(Scene_Book)
#     SceneManager.scene.set_book(Guide, Scene_Map)
#
#   show_book is a little faster, though. You can replace Guide with the name
#   of your book to show whatever you'd like - let's say we have a book window
#   named Biology_Textbook. We would use this:
#
#   show_book(Biology_Textbook, Scene_Map)
#
#   Note that show_book will return to the scene that you enter as its second
#   parameter when the book is closed. It defaults to Scene_Map if no scene is
#   given - I simply included Scene_Map in the examples to show that you can
#   designate a scene.
#
#   That's it! Congratulations, you've created a guide! Your players will never
#   have to puzzle over the controls again!
#
#   Anyway, I hope you can see how easy it is to use this as a base to make
#   your own books. I can't wait to see what you come up with - make sure to
#   let me know if you use it! Feel free to read over the rest of the script if
#   you're learning to write code or are simply curious - it's my most
#   thoroughly commented to date and may be able to give you some pointers.
#
# License
# -----------------------------------------------------------------------------
# This script is made available under the terms of the MIT Expat license.
# View [this page](http://sesvxace.wordpress.com/license/) for more detailed
# information.
# 
#++
                    ($imported ||= {})["SES - Window Book"] = 3.0
#==============================================================================
#   Window_Book
#------------------------------------------------------------------------------
#   This is a parent class for multi-page windows of various kinds. The most
#   basic use for it is to make books.
#==============================================================================
class Window_Book < Window_Base
  #============================================================================
  #   Local Variables
  #----------------------------------------------------------------------------
  #     The most important one of these, as well as the only one that is
  #     initialized here, is @pagetext. @pagetext is a hash of arrays, one per
  #     page of the book. The arrays contain strings that represent the text
  #     on the page. The text will automatically wrap to avoid going off of the
  #     screen. Each separate string moves down to a new line - \n will not
  #     work in the text strings. Any of the standard control characters for a
  #     VXAce message window will, however. When write_page_text is called, the
  #     text for the current page will be drawn onto the window.
  #============================================================================
  attr_accessor :pagetext
  #============================================================================
  #   Initialize
  #----------------------------------------------------------------------------
  #     Sets up the window.
  #     Takes an x-coordinate, a y-coordinate, the width of the window,
  #     the height of the window, the wrap type, whether or not to draw the page
  #     number for a book with only one page, and the name of the windowskin
  #     you want the book to use (optional, must be a Bitmap [the class, not
  #     the file type]). The wrap type can be either :word or :char. :word
  #     wrapping will wrap text to a new line at word boundaries, while :letter
  #     wrapping will wrap it at character boundaries, which can avoid issues
  #     with absurdly long words - though it is unlikely to ever be necessary,
  #     as not many (real) words would be wider than the game window. It is
  #     only likely to be an issue if your child window is very small. By
  #     default, the window will cover the entire game screen. Please also note
  #     that escape characters are not available in :letter wrap mode, which
  #     should be obvious as it processes letter-by-letter. I may include
  #     handling to alter that later, but for now stick to word wrap mode if
  #     you're using escape characters.
  #============================================================================
  def initialize(x = 0, y = 0, width = Graphics.width, height = Graphics.height,
                 wrap_type = :word, draw_scroll_for_one = false, skin = nil)
    #==========================================================================
    #   Here we set the windowskin for the book. It can be provided in the
    #   constructor of your window when it calls super, or you can rely on this
    #   default setting which will, if my Window Swap script is active, cause
    #   it to use a file called "Book Window" found in the Graphics/Windows
    #   folder. If you are not using the aforementioned script, it will use the
    #   default windowskin. You may modify this section to change the default
    #   setting if you wish, but I would leave in the "skin ||" part so that
    #   children of this class can still provide their own windows.
    #
    #   If you choose to provide a windowskin from a child class, it must be as
    #   a Bitmap rather than a file name, so remember to load it up. A child
    #   window's call to this method that provides a windowskin would look
    #   something like this:
    #   super(0, 0, 544, 416, Cache.windows("Child Window"))
    #
    #   We also set @wrap to our desired wrap type and initialize @pagetext to
    #   an empty hash with an empty array as its default value, though if
    #   @pagetext has already been initialized (which it should have in a child
    #   class) it will only set the default, not empty the hash.
    #==========================================================================
    @skin = skin || 
            ($imported["ESSA - Window Swap"] ? Cache.windows("Book Window") :
                                               Cache.system("Window"))
    @wrap = wrap_type and @pagetext ||= {} and @pagetext.default = []
    @draw_scroll_for_one = draw_scroll_for_one
    super(x, y, width, height)
    #==========================================================================
    #   This sets the Z-value of the window to 255, to make sure
    #   that it displays on top of everything else, and defaults @page (a local
    #   variable that holds an integer that determines the current page) to 1.
    #   It then builds the window's contents and sets it as the active window.
    #==========================================================================
    self.z, @page = 255, 1
    refresh
    activate
  end
  #============================================================================
  #   Update
  #----------------------------------------------------------------------------
  #     Updates the window.
  #============================================================================
  def update
    super
    #==========================================================================
    #   Here we check for action from the directional keys - scrolling between
    #   pages and up/down within a page, if applicable. It also updates the
    #   page number display at the bottom of the window.
    #==========================================================================
    process_cursor_move
    @scrolldata.each_value { |v| v.update } if @scrolldata
  end
  #============================================================================
  #   Dispose
  #----------------------------------------------------------------------------
  #     Disposes the window.
  #============================================================================
  def dispose
    #==========================================================================
    #   This disposes the page number display at the bottom of the window when
    #   the window is closed. It has to be done before the call to super, or
    #   the window will be disposed first, which prevents us from disposing
    #   any remaining pieces of it. That would leave the numbers and page arrows
    #   floating on the screen, which we do not want.
    #==========================================================================
    @scrolldata.each_value { |v| v.dispose } if @scrolldata
    super
  end
  #============================================================================
  #   Max Pages
  #----------------------------------------------------------------------------
  #     The total number of pages that the book contains.
  #     Override this in your child class and have it return the number of
  #     pages that your book has. I chose to do this with a method rather than
  #     a variable as by using a method logic can be implemented, varying the
  #     number of pages in different situations.
  #============================================================================
  def max_pages() 1 end
  #============================================================================
  #   Scroll Speed
  #----------------------------------------------------------------------------
  #     The number of pixels by which the window is scrolled when moving up and
  #     down within a page.
  #     This can be overriden by child classes to allow for different scroll
  #     speed. Perhaps one child window is a normal book and another is some
  #     sort of futuristic datapad that has a greater reaction to scrolling than
  #     a book would.
  #============================================================================  
  def scroll_speed() 6 end
  #============================================================================
  #   DY
  #----------------------------------------------------------------------------
  #     How far from the top of the window the first text will be drawn.
  #     Override this in your child class and have it return the height (often
  #     in lines - this method is typically defined as # * line_height) that
  #     you wish to have as the offset. My reasoning for having this as a
  #     method is the same as my reasoning for having Max Pages as a method.
  #============================================================================
  def dy() 0 end
  #============================================================================
  #   Draw Text EX
  #----------------------------------------------------------------------------
  #     Overwrites the method from Window_Base to prevent automatic resetting of
  #     font properties in between calls.
  #============================================================================
  def draw_text_ex(x, y, text, reset = true)
    reset_font_settings if reset
    text = convert_escape_characters(text)
    pos = {:x => x, :y => y, :new_x => x, :height => calc_line_height(text)}
    process_character(text.slice!(0, 1), text, pos) until text.empty?
  end
  #============================================================================
  #   Refresh
  #----------------------------------------------------------------------------
  #     Refreshes the window.
  #============================================================================
  def refresh
    #==========================================================================
    #   Here we set the Y-origin for the window's display to 0, so that the new
    #   page will display from the top even if the player had scrolled all the
    #   way to the bottom of the previous page. We also build the contents for
    #   the current page, draw the page number display, and then draw whatever
    #   the page is intended to contain. When creating a child window for this
    #   class, make sure to create a draw_page# method for each page in the
    #   window. I've set things up so that a page will remain blank (or display
    #   its text from @pagetext, if it has any) if the method doesn't exist
    #   rather than throwing an error and crashing, but that's no excuse to
    #   leave a poor little page without a handler! Well, unless you're just
    #   displaying text, but still. Try to be creative! You can create
    #   encyclopedias with pictures, or magazines with articles set in various
    #   column styles, or dozens of other things! Don't limit yourself to just
    #   plain books - though those are good, too.
    #==========================================================================
    self.oy = 0
    create_contents and draw_scroll
    send("draw_page#{@page}")
    return true
  end
  #============================================================================
  #   Contents Height
  #     Returns the height of the window's contents.
  #----------------------------------------------------------------------------
  #     This is used to calculate whether or not the window needs to be able to
  #     scroll, among other things.
  #
  #     If you create a child window that uses more than just text, you will
  #     probably have to overwrite this method. Make sure to include a call to
  #     the super somewhere in your method - you will likely want to add
  #     something to the result of the super to get the height of the window.
  #     For example, say we have a page with an image that is 54 pixels tall,
  #     and we want to include it as well as a 3 pixel border at the top and
  #     bottom in addition to some text from @pagetext. The picture is only on
  #     page 2. We would have a method that looks something like this inside of
  #     our child class:
  #     def contents_height
  #       addedHeight = if @page == 2 then 60
  #                     else 0 end
  #       super + addedHeight
  #     end
  #
  #     It takes a padding value, used to determine the amount of vertical
  #     padding to give the window. It also takes a value that will be used to
  #     determine the maximum width of a given line - important for determining
  #     the total height, as without it lines of variable length will not be
  #     assessed correctly for wrapping. This value can be a static Integer
  #     value or a Symbol that points to a method.
  #============================================================================
  def contents_height(padding = 2, twid = :contents_width, text = @pagetext, l_x = 0)
    #==========================================================================
    #   Here we set i equal to dy / line_height + 1, or the number of lines
    #   that appear above our text as well as a line of padding at the bottom.
    #   i is an integer that holds the number of rows of text that the page
    #   contains. It is multiplied by 24 to find the height of the contents in
    #   pixels. We also create b, a dummy bitmap used to test the size of the
    #   text to help determine whether or not we need to wrap to a new row. b
    #   is necessary because the contents of the window, which would normally
    #   be used for the text_size method, are disposed during the
    #   create_contents method, which is where this is most needed.
    #==========================================================================
    i, b = dy / line_height + 1, Bitmap.new(1,1)
    #==========================================================================
    #   In here we loop through the strings in @pagetext's array for the
    #   current page. In word wrap mode we break them apart into words by
    #   splitting them at spaces, then test if adding the next word would cause
    #   the line to run off of the window. If it would, we instead add a new
    #   line. In character wrap mode, we break it apart at each character
    #   instead of each space. If wrapping occurs, we ignore leading spaces in
    #   order to avoid unnecessary white space.
    #==========================================================================
    text = text[@page ||= 1] if text.is_a?(Hash)
    text.each do |l|
      if l.is_a?(String)
        i = calc_height(split_for_height(l), i, twid, l_x, 0, 1, b) + 1
      elsif l.is_a?(Array)
        ia = [i] * l.size
        l.each_with_index do |c,ci|
          c.each do |t|
            ia[ci] = calc_height(split_for_height(t), ia[ci],
                                 twid, l_x, ci, l.size, b)
          end
        end
        i = ia.max
      end
    end
    #==========================================================================
    #   Here we return the number of lines as a number of pixels, if it's
    #   larger than the default height given. If not, it uses the default
    #   height.
    #==========================================================================
    return [line_height*(i+1), height - standard_padding * padding].max
  end
  #============================================================================
  #   Split for Height
  #----------------------------------------------------------------------------
  #     Splits the given text based on wrap type. Used by contents_height.
  #============================================================================
  def split_for_height(text)
    if @wrap == :word then return text.split(/\s/)
    else return text.split(//) end
  end
  #============================================================================
  #   Calc Height
  #----------------------------------------------------------------------------
  #     Calculates the height of the window. Called by contents_height.
  #============================================================================
  def calc_height(text, i, twid, l_x, offset, len, b)
    cec, x = /\\(\w)(\[(\w+)\])?/, l_x
    text.each do |w|
      dw = convert_escape_characters(w).gsub(cec) { '' }
      wx = text_width(twid, i) / len - (len > 1 && offset < len - 1 ? 12 : 0)
      wid = x + b.text_size(dw).width
      if wid > wx
        i += 1 and x = l_x
        wx = text_width(twid, i) / len - (len > 1 && offset < len - 1 ? 12 : 0)
      end
      next if x == l_x && w == " " or x += b.text_size(dw).width
    end
    return i + 1
  end
  #============================================================================
  #   Method Missing
  #----------------------------------------------------------------------------
  #     Handles missing draw_page# methods to prevent errors.
  #============================================================================
  def method_missing(method)
    #==========================================================================
    #   Here we check whether the missing method is a draw_page# method. If it
    #   is, we default to using write_page_text to print the page's information
    #   from @pagetext. If it's not, an error will be thrown.
    #==========================================================================
    if method =~ /^draw_page(\d+)$/ then write_page_text
    else super end
  end
  #============================================================================
  #   Text Width
  #     Calculates the maximum horizontal space available for drawing text on a
  #     given line.
  #----------------------------------------------------------------------------
  #     This method takes a width, which can be either a static Integer value
  #     or a Symbol pointing to a method. It also takes an optional parameter
  #     to pass to a method, if one is called. This parameter will only be
  #     passed if the method can take parameters.
  #============================================================================  
  def text_width(twid = :contents_width, i = 0)
    #==========================================================================
    #   Here we check whether the passed value is a Symbol or not. If it is, we
    #   move on to determining whether or not to pass it a parameter. If it
    #   isn't, we return the value.
    #==========================================================================
    if twid.is_a?(Symbol)
      #=========================================================================
      #   Here we check whether the passed method can take parameters. If it
      #   can't, we call the method with no parameters. If it can, we call it
      #   with the given parameter.
      #=========================================================================
      method(twid).parameters.empty? ? send(twid) : send(twid, i)
    else
      return twid
    end
  end
  #============================================================================
  #   Write Page Text
  #     Begins and coordinates processing for writing text to a page.
  #----------------------------------------------------------------------------
  #     I love all of my daughter here dearly, but these next three methods are
  #     my favourite of her many features. They're the script equivalent of a
  #     beautiful singing voice, really.
  #     Together, these methods take the strings contained in @pagetext and
  #     write them to the screen, wrapping to the next line at word boundaries
  #     when it becomes necessary. You may also tell them to use a letter wrap,
  #     in which case it will wrap at lettter boundaries rather than those of
  #     words.
  #     You can call this method with an array and a starting line in order
  #     to place text wherever you'd like. Additionally, you may specify a
  #     newline boundary to add to the front of any wrapped line, allowing you
  #     to tab long lines in lists. You can specify a method or integer value
  #     that will be used to calculate the maximum width of the line, allowing
  #     for dynamic line length. This is useful when dealing with things like
  #     pictures. Finally, you may specify an x value at which all lines should
  #     begin.
  #============================================================================
  def write_page_text(text = @pagetext[@page], i = 0, newline_boundary = "",
                      mode = :ex, twid = :contents_width, l_x = 0)
    reset_font_settings
    #==========================================================================
    #   In here we loop through the strings in the text array for the current
    #   page. In word wrap mode we break them apart into words by splitting
    #   them at spaces, then test if adding the next word would cause the line
    #   to run off of the window. If it does not, we write the word to the
    #   screen. If it would, we add a new line and then write the word. In
    #   character wrap mode, we break it apart at each character instead of
    #   each space. If wrapping occurs, we ignore leading spaces in order to
    #   avoid unnecessary white space. It returns the index of the next empty
    #   row.
    #=========================================================================
    @page ||= 1
    text.each do |l|
      if l.is_a?(String)
        i = write_text(split_text(l), i, newline_boundary,
                       mode, twid, l_x, 0, 1) + 1
      elsif l.is_a?(Array)
        ia = [i] * l.size
        l.each_with_index do |c,ci|
          c.each do |t|
            ia[ci] = write_text(split_text(t), ia[ci], newline_boundary,
                                mode, twid, l_x, ci, l.size) + 1
          end
        end
        i = ia.max
      end
      reset_font_settings
    end
    return i
  end
  #============================================================================
  #   Split Text
  #     Divides text and separates control characters from that which will be
  #     drawn on the screen.
  #----------------------------------------------------------------------------
  #     This method is given text by write_page_text. It examines the text and
  #     cuts out escape characters, allowing them to work properly. It also
  #     splits the text itself into individual words (or letters, in letter wrap
  #     mode) so that wrap points can be determined safely.
  #============================================================================
  def split_text(text)
    if @wrap == :word
      text, skip = text.split(/\s/), -1
      cc = /(\\\w\[\w+\])(.+)/
      text.each_with_index do |w,i|
        next if i < skip
        w << ' ' unless w[-1] == ' '
        rarr = []
        w.sub!(cc) do
          vals = [$1, $2]
          $2 =~ /^(\s*)$/ ? rarr.concat(['', vals[0]]) : rarr << vals[0]
          "SpLiThErE#{vals[1]}"
        end while w =~ cc
        unless rarr.empty?
          w.sub!(/^SpLiThErE/) { '' }
          warr = w.split('SpLiThErE') and text.delete_at(i)
          until rarr.empty? && warr.empty?
            t = '' << (rarr[0] ? rarr.shift : '') << (warr[0] ? warr.shift : '')
            text.insert(i, t) and i += 1
          end
          skip = i
        end
      end
    else text = text.split(//) end
    return text
  end
  #============================================================================
  #   Write Text
  #     Writes text on the page.
  #----------------------------------------------------------------------------
  #     This method is where the actual writing takes place. write_page_text
  #     gives it an array of text that has been processed by split_text. It goes
  #     through the array and writes each of its strings to the screen, moving
  #     to a new line if it determines that text cannot be written on the
  #     current line without going over its maximum length.
  #============================================================================
  def write_text(text, i, newline_boundary, mode, twid, l_x, offset, len)
    cec, cc, x = /\e(\w)(\[(\w+)\])?/, "", l_x
    text.each do |w|
      cc = ''
      w = convert_escape_characters(w).gsub(cec) { |s| cc += s and '' }
      wx = text_width(twid, i) / len - (len > 1 && offset < len - 1 ? 12 : 0)
      wid = x + text_size(w.rstrip).width
      if wid > wx
        i += 1 and x = l_x and w.insert(0, newline_boundary)
        wx = text_width(twid, i) / len - (len > 1 && offset < len - 1 ? 12 : 0)
      end
      rect = Rect.new(x + wx * offset, i * line_height + dy, wx,
                      line_height)
      next if x == l_x && w =~ /^\s+$/
      draw_text_ex(rect.x, rect.y, cc, false) if !cc.empty?
      draw_text(rect, w)
      x += text_size(w).width
    end
    return i
  end
  #============================================================================
  #   Arrow Bitmap
  #     Defines the bitmap from which the window's arrows will be taken.
  #----------------------------------------------------------------------------
  #     This will provide the arrow sprites with the windowskin in order to get
  #     their arrows if they should be visible.
  #============================================================================
  def arrow_bitmap(d)
    #==========================================================================
    #   Here we check what page we're on. If we're past the first page we'll
    #   give the left arrow the windowskin so that it will be visible, and if
    #   we're not on the last page we'll give it to the right arrow.
    #==========================================================================
    self.windowskin if (@page < max_pages && d == :r) || (@page > 1 && d == :l)
  end
  #============================================================================
  #   SX
  #     The base X position for the page number data.
  #----------------------------------------------------------------------------
  #     This calculates where in the X plane the page number and arrows
  #     generated by draw_scroll should be placed.
  #============================================================================
  def sx
    #==========================================================================
    #   We take the maximum possible size for the page number display and
    #   devise a starting X coordinate based on that.
    #==========================================================================
    self.x + 
    (contents_width - text_size("#{max_pages}/#{max_pages}").width + 4) / 2 - 5
  end
  #============================================================================
  #   Scrolldata
  #     Returns information about the page number display, including the source
  #     information for the arrows.
  #----------------------------------------------------------------------------
  #     This returns a hash of information, all of which will be drawn by
  #     draw_scroll when it is run.
  #============================================================================
  def scrolldata
    #==========================================================================
    #   First we calculate an X value to help us display the right arrow. After
    #   that, we calculate the y value at which the information should be
    #   drawn.
    #==========================================================================
    x = text_size("#{max_pages}/#{max_pages}").width + 4
    y = if Graphics.height - height == 0 then height - 28
        else self.y + height - 28 end
    #==========================================================================
    #   Here's the meat of the method. You may need to edit the src_rect
    #   information for the arrows if you're using a custom windowskin - it's
    #   configured to use the base. Note that each of the keys in this hash
    #   will become a Sprite object when draw_scroll is called.
    #
    #   Each key in the main hash is linked to a second hash. There are 5
    #   possible values in that second hash:
    #   :x => Easy enough. This is the X coordinate at which the item will be
    #         drawn.
    #   :y => Also easy - the Y coordinate for drawing.
    #   :bitmap => The Sprite's bitmap. For :pagecount, this should be an empty
    #         bitmap placed at the x we calculated earlier. Its height should
    #         be equivalent to line_height - I simply set it at 24 (the default
    #         value for line_height) for visibility.
    #   :src_rect => The visible portion of the Sprite's bitmap. You'll need to
    #         change this for :rarrow and :larrow if you're using a custom
    #         windowskin that has arrows of a different size than those in the
    #         default window.
    #   :d_rect => :pagecount only. This should be the same as :src_rect. It
    #         exists to simplify drawing the page numbers and so that if you
    #         overwrite/extend this method with new Sprites you can have the
    #         page numbers drawn in the way you want.
    #==========================================================================
    { :pagecount => { :x => sx + 10, :y => y - 7, :bitmap => Bitmap.new(x, 24),
        :src_rect => Rect.new(0,0,x+4,line_height),
        :d_rect => Rect.new(0, 0, x + 4, line_height) },
        :rarrow => { :x => sx + x + 28, :y => y-1, :bitmap => arrow_bitmap(:r),
                   :src_rect => Rect.new(104,25,8,14) },
        :larrow => { :x => sx - 12, :y => y-1, :bitmap => arrow_bitmap(:l),
                     :src_rect => Rect.new(80,25,8,14) }
    }
  end
  #============================================================================
  #   Draw Scroll
  #     Draws the sprites defined in Scrolldata.
  #----------------------------------------------------------------------------
  #     This takes the hash from Scrolldata and creates a sprite for each key,
  #     using the values defined in the key's hash.
  #============================================================================
  def draw_scroll
    return if max_pages == 1 && !@draw_scroll_for_one
    (@scrolldata ||= {}).each_value { |s| s.dispose }.clear
    #==========================================================================
    #   First we get the key and value pair from the hash. We then create the
    #   Sprite and set its x, y, and z values as well as its bitmap and
    #   src_rect. After that, we draw the page numbers in any Sprite that has a
    #   d_rect defined.
    #==========================================================================
    scrolldata.each_pair do |k,v|
      @scrolldata[k] = Sprite.new
      @scrolldata[k].x, @scrolldata[k].y, @scrolldata[k].z = v[:x], v[:y], 255
      @scrolldata[k].bitmap, @scrolldata[k].src_rect = v[:bitmap], v[:src_rect]
      if v[:d_rect]
        @scrolldata[k].bitmap.draw_text(v[:d_rect], "#{@page}/#{max_pages}", 1)
      end
    end
  end
  #============================================================================
  #   Process Cursor Move
  #     Checks whether or not the player is scrolling through the window.
  #----------------------------------------------------------------------------
  #     This method checks for direction key input and performs actions based
  #     on whether or not there is.
  #============================================================================
  def process_cursor_move
    #==========================================================================
    #   First we set oldpage to the current page number, so that we can check
    #   if the page ended up changing. Then we check if the player has pressed
    #   left - if they have and we are not on the first page, we go back a
    #   page. After that we check if they have pressed right, and go forward if
    #   we are not on the last page. Then we move on to scrolling up and down
    #   within a page - if they hit up and are not at the top of the page, it
    #   will scroll up, and if they hit down and are not at the bottom of the
    #   page it will scroll down. After we are done checking for input, we
    #   redraw the page if the page has changed.
    #==========================================================================
    if @changed
      @changed = false
      return
    end
    oldpage = @page
    if Input.trigger?(:LEFT) && 1 < @page
      @page -= 1
    elsif Input.trigger?(:RIGHT) && @page < max_pages
      @page += 1
    elsif ((Input.press?(:UP)) if Input.repeat?(:UP)) && self.oy > 0
      self.oy -= [scroll_speed, [0, (height+oy+contents_height-24)].min.abs].max
      draw_scroll
    elsif ((Input.press?(:DOWN)) if Input.repeat?(:DOWN))
      self.oy += [scroll_speed, [0, contents_height + 24 - height - oy].max].min
      draw_scroll
    end
    if oldpage != @page
      refresh and @changed = true
    end
    return true
  end
end

#==============================================================================
#   SceneManager
#------------------------------------------------------------------------------
#     This is the default module that handles Scene processing. I have defined
#     a push_to_stack method to allow scenes to be added to the SceneManager
#     stack from outside of the module.
#==============================================================================
module SceneManager
  #============================================================================
  #   Push to Stack
  #     Adds a scene to the stack.
  #----------------------------------------------------------------------------
  #     This method takes an instance of a scene and adds it at the end of the
  #     stack of scenes called with the use of SceneManager.return.
  #============================================================================
  def self.push_to_stack(scene)
    @stack << scene
  end
end

#==============================================================================
#   Game_Interpreter
#------------------------------------------------------------------------------
#     This is a default class that handles event processing. I have defined the
#     show_book method in here to allow for quick display of simple books.
#==============================================================================
class Game_Interpreter
  #============================================================================
  #   Show Book
  #     Calls the Scene_Book class.
  #----------------------------------------------------------------------------
  #     This method takes the name of a book class (and potentially a second
  #     scene to go to after the player closes the book - if no second scene is
  #     entered it will default to the current scene) and displays the book
  #     contained in the class.
  #============================================================================
  def show_book(book, scene = SceneManager.scene)
    SceneManager.call(Scene_Book) and SceneManager.scene.set_book(book, scene)
  end
end

#==============================================================================
#   Scene_Book
#------------------------------------------------------------------------------
#     This is a class that displays simple books. It allows the player to read
#     the book, and will return to the given scene when closed.
#==============================================================================
class Scene_Book < Scene_Base
  #============================================================================
  #   Set Book
  #     Sets the book that the class should display as well as the class that
  #     the game should go to when the player closes the book.
  #----------------------------------------------------------------------------
  #     This method takes the name of a book class and sets the scene's book
  #     object to the given book. It also takes the name of a class, and sets
  #     the class that will open when the book is closed to that class.
  #============================================================================
  def set_book(book, scene = nil)
    @book = (book.class == Class ? book.new : book)
    if scene
      SceneManager.push_to_stack(scene.class == Class ? scene.new : scene)
    end
  end
  #===========================================================================
  #   Update
  #     Updates the class.
  #----------------------------------------------------------------------------
  #     If the scene contains a book, it updates the book. If there is no book,
  #     it will wait for one to be given with set_book. If the player presses
  #     a Cancel button, it will close the book and go to the next scene.
  #============================================================================
  def update
    super
    @book.update if @book
    SceneManager.return if Input.trigger?(:B)
  end
end