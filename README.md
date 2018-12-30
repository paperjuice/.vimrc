# .vimrc

### Description
This is my personal vim initialization file.

I will constantly update this with any mapping/functions that I consider to ease my life.

### Functionalities
Besides some straight-forward bindings, I also have:
  * :Rl<line_number> - removes the last character on each line from cursor position until the specified row no.
  ```
  :Rl4 (cursor at line 1)
  ```
  ``` shell
  1 aaad               1 aa
  2 aaaaaaad     ->    2 aaaaaaa
  3 aaaaaaf            3 aaaaaa
  4 ac                 4 a
  ```
  
  * :Cm<line_number> - comments(add # at the beginning of line) from cursor position to specified line
  ```
  :Cm4 (cursor at line 1)
  ```
  ``` shell
  1 aaad               1 #aad
  2 aaaaaaad     ->    2 #aaaaaaad
  3 aaaaaaf            3 #aaaaaaf
  4 ac                 4 #ac
  ```

  * :Add<line_number> - add character at the end of the row from cursor position to specified line
  ```
  :Add1 hello (cursor at line 1)
  ```
  ``` shell
  1 aaad               1 aadhello
  2 aaaaaaad     ->    2 aaaaaaadhello
  3 aaaaaaf            3 aaaaaafhello
  4 ac                 4 achello
  ```


### TODO
* Come up with better names maybe
* Shortcut for buffer width resizing.(:vertical resize +/-x)
