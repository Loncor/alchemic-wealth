---
title: PL/SQL Naming Convention - Identifiers
layout: default
---
# What is an PL/SQL identifier?

An [Identifier](http://en.wikipedia.org/wiki/Identifier#In_computer_science) is a name the developer chooses for an entity in a programs source code. For PL/SQL *examples* of Identifiers are **variables**, **types** and **procedures**.

In PL/SQL identifier names are quite restrictive. They must always begin with a letter followed by *zero or more* other characters which can only be:
* letters ( a to z or A to Z )
* numbers ( 0 to 9 )
* underscores ( _ )
* hashes ( # ).
* dollar signs ( $ )

The identifier length must be a **maximum 30 characters**. Identifiers are not case sensitive so I would recommend using underscores( _ ) rather than [camelCase](https://en.wikipedia.org/wiki/Camel_case) not the least reason being formatters that could turn ones carefully crafted humps into lower case. One thing that is not often mentioned is the letters can only come from the [Modern English alphabet](https://en.wikipedia.org/wiki/English_alphabet).

You can get further information from Oracle documention on [Identifiers](https://docs.oracle.com/cd/B28359_01/appdev.111/b28370/fundamentals.htm#i6075).

Below, all items highlighted
in <span style="color:maroon">maroon</span> are identifiers which, from another perspective, are any names that are not a PL/SQL [reserved word](http://en.wikipedia.org/wiki/Reserved_word).

<pre><span class="plsql_resword">function</span> <span class="plsql_userword">get_approved_frame_height</span> <span class="plsql_brackets">(</span><span class="plsql_userword">in_frame_width</span> <span class="plsql_resword">in</span> <span class="plsql_resword">number</span><span class="plsql_brackets">)</span>
<span class="plsql_resword">return</span> <span class="plsql_resword">number</span> <span class="plsql_resword">is</span>
   <span class="plsql_userword">fnk_golden_ratio</span>       <span class="plsql_resword">constant</span> <span class="plsql_resword">number</span> := <span class="plsql_brackets">(</span> 1 + <span class="plsql_resword">sqrt</span><span class="plsql_brackets">(</span>5<span class="plsql_brackets">)</span> <span class="plsql_brackets">)</span> / 2;
<span class="plsql_resword">begin</span>
   <span class="plsql_resword">return</span> <span class="plsql_userword">in_frame_width</span> * <span class="plsql_userword">fnk_golden_ratio</span>;
<span class="plsql_resword">end</span> <span class="plsql_userword">get_approved_frame_height</span>; </pre>
