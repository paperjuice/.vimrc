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
  
### TODO
* Add specified characters at the end of every line
* Comment all lines from cursor position to the specified number
