---
title: PL/SQL Naming Convention - Nested Functions
layout: default
---
# Nested Functions, Blocks and For loops

In PL/SQL **functions**, **blocks** and **for loops** can all be nested which and identifiers with the same name are selected via 
the scoping rules. To access the identifier outside the scope one needs to a different name. I suggest just adding one or more # 
charcters to end of prefix. For instance, in the following code to access the out of scope variable a # character is added. 

<pre><span class="plsql_resword">function</span> <span class="plsql_userword">outer_function</span>
<span class="plsql_resword">return</span> <span class="plsql_resword">integer</span> <span class="plsql_resword">is</span>
   <span class="plsql_userword">fi_an_integer</span> <span class="plsql_resword">integer</span> := 3;
   
   <span class="plsql_resword">function</span> <span class="plsql_userword">inner_function</span>
   <span class="plsql_resword">return</span> <span class="plsql_resword">integer</span> <span class="plsql_resword">is</span>
      <span class="plsql_userword">fi#_an_integer</span> <span class="plsql_resword">integer</span> := 4;
   <span class="plsql_resword">begin</span>
      <span class="plsql_resword">return</span> <span class="plsql_userword">fi#_an_integer</span> + <span class="plsql_userword">fi_an_integer</span>;
   <span class="plsql_resword">end</span> <span class="plsql_userword">inner_function</span>;
<span class="plsql_resword">begin</span>
   <span class="plsql_resword">return</span> <span class="plsql_userword">inner_function</span>;
<span class="plsql_resword">end</span> <span class="plsql_userword">outer_function</span>; </pre>

It is possible that deeper levels of nesting will require multiple #, so an alternative method of naming is recommended.


