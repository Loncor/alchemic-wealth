---
title: PL/SQL Naming Convention - Example
layout: default
---
## An example of this PL/SQL Naming Convention

In the trivial example below there is a [**semantic error**](https://www.thefreedictionary.com/semantic+error) because the database column name is the same as the variable name. Note: This does compile and the error will only be picked up during debugging.

<pre><span class="plsql_resword">function</span> <span class="plsql_userword">get_tax_rate_bug</span> <span class="plsql_brackets">(</span> <span class="plsql_userword">tax_region</span>    <span class="plsql_resword">in</span> <span class="plsql_userword">region_tax_rates_bug</span>.<span class="plsql_userword">tax_region</span>%<span class="plsql_resword">type</span>,
                            <span class="plsql_userword">tax_date</span>      <span class="plsql_resword">in</span> <span class="plsql_userword">region_tax_rates_bug</span>.<span class="plsql_userword">start_tax_date</span>%<span class="plsql_resword">type</span> := <span class="plsql_resword">trunc</span><span class="plsql_brackets">(</span><span class="plsql_resword">sysdate</span><span class="plsql_brackets">)</span> <span class="plsql_brackets">)</span>
<span class="plsql_resword">return</span> <span class="plsql_userword">region_tax_rates_bug</span>.<span class="plsql_userword">tax_rate</span>%<span class="plsql_resword">type</span> <span class="plsql_resword">is</span>
   <span class="plsql_resword">cursor</span> <span class="plsql_userword">region_tax_rate</span><span class="plsql_brackets">(</span> <span class="plsql_userword">tax_region</span>    <span class="plsql_resword">in</span> <span class="plsql_userword">region_tax_rates_bug</span>.<span class="plsql_userword">tax_region</span>%<span class="plsql_resword">type</span>,
                           <span class="plsql_userword">tax_date</span>      <span class="plsql_resword">in</span> <span class="plsql_userword">region_tax_rates_bug</span>.<span class="plsql_userword">start_tax_date</span>%<span class="plsql_resword">type</span> <span class="plsql_brackets">)</span> <span class="plsql_resword">is</span>
      <span class="plsql_resword">select</span> <span class="plsql_userword">tax_rate</span>
        <span class="plsql_resword">from</span> <span class="plsql_userword">region_tax_rates_bug</span>
       <span class="plsql_resword">where</span> <span class="plsql_userword">tax_region</span> = <span class="plsql_userword">tax_region</span>
         <span class="plsql_resword">and</span> <span class="plsql_userword">tax_date</span> <span class="plsql_resword">between</span> <span class="plsql_userword">start_tax_date</span> <span class="plsql_resword">and</span> <span class="plsql_userword">end_tax_date</span>
        <span class="plsql_resword">order</span> <span class="plsql_resword">by</span> <span class="plsql_userword">start_tax_date</span> <span class="plsql_resword">desc</span>;
<span class="plsql_resword">begin</span>
   <span class="plsql_resword">for</span> <span class="plsql_userword">rtr</span> <span class="plsql_resword">in</span> <span class="plsql_userword">region_tax_rate</span><span class="plsql_brackets">(</span><span class="plsql_userword">tax_region</span>, <span class="plsql_userword">tax_date</span><span class="plsql_brackets">)</span> <span class="plsql_userword">loop</span>
      <span class="plsql_resword">return</span> <span class="plsql_userword">rtr</span>.<span class="plsql_userword">tax_rate</span>;
   <span class="plsql_resword">end</span> <span class="plsql_userword">loop</span>;

   <span class="plsql_resword">return</span> <span class="plsql_resword">null</span>;
<span class="plsql_resword">end</span> <span class="plsql_userword">get_tax_rate_bug</span>; </pre>

Adding prefixes to the variables in the corrected example below documents the code as follows:-

*   the `is_` prefix indicates the identifier `is_tax_region` is an input string parameter whose scope is confined to the function and where it is called.
*   the `id_` prefix indicates the identifier `id_tax_date` is an input date parameter whose scope is confined to the function and where it is called.
*   the `cs_` prefix indicates the identifier `cs_tax_region` is a cursor input string parameter whose scope is confined to the cursor definition and where it is called.
*   the `cd_` prefix indicates the identifier `cd_tax_date` is a cursor input date parameter whose scope is confined to the cursor definition and where it is called.
*   the `fq_` prefix indicates the identifier `fq_region_tax_rate` is a cursor whose scope is confined to the function.
*   the `lr_` prefix indicates the identifier `lr_rtr` is an record whose scope is confined to its locale, which is the area within the for loop.

<pre><span class="plsql_resword">function</span> <span class="plsql_userword">get_tax_rate</span> <span class="plsql_brackets">(</span> <span class="plsql_userword">is_tax_region</span>    <span class="plsql_resword">in</span> <span class="plsql_userword">region_tax_rates</span>.<span class="plsql_userword">s_tax_region</span>%<span class="plsql_resword">type</span>,
                        <span class="plsql_userword">id_tax_date</span>      <span class="plsql_resword">in</span> <span class="plsql_userword">region_tax_rates</span>.<span class="plsql_userword">d_start_tax_date</span>%<span class="plsql_resword">type</span> := <span class="plsql_resword">trunc</span><span class="plsql_brackets">(</span><span class="plsql_resword">sysdate</span><span class="plsql_brackets">)</span> <span class="plsql_brackets">)</span>
<span class="plsql_resword">return</span> <span class="plsql_userword">region_tax_rates</span>.<span class="plsql_userword">n_tax_rate</span>%<span class="plsql_resword">type</span> <span class="plsql_resword">is</span>
   <span class="plsql_comment">-- Cursors
</span>   <span class="plsql_resword">cursor</span> <span class="plsql_userword">fq_region_tax_rate</span><span class="plsql_brackets">(</span> <span class="plsql_userword">cs_tax_region</span>    <span class="plsql_resword">in</span> <span class="plsql_userword">region_tax_rates</span>.<span class="plsql_userword">s_tax_region</span>%<span class="plsql_resword">type</span>,
                              <span class="plsql_userword">cd_tax_date</span>      <span class="plsql_resword">in</span> <span class="plsql_userword">region_tax_rates</span>.<span class="plsql_userword">d_start_tax_date</span>%<span class="plsql_resword">type</span> <span class="plsql_brackets">)</span> <span class="plsql_resword">is</span>
      <span class="plsql_resword">select</span> <span class="plsql_userword">n_tax_rate</span>
        <span class="plsql_resword">from</span> <span class="plsql_userword">region_tax_rates</span>
       <span class="plsql_resword">where</span> <span class="plsql_userword">s_tax_region</span> = <span class="plsql_userword">cs_tax_region</span>
         <span class="plsql_resword">and</span> <span class="plsql_userword">cd_tax_date</span> <span class="plsql_resword">between</span> <span class="plsql_userword">d_start_tax_date</span> <span class="plsql_resword">and</span> <span class="plsql_userword">d_end_tax_date</span>
        <span class="plsql_resword">order</span> <span class="plsql_resword">by</span> <span class="plsql_userword">d_start_tax_date</span> <span class="plsql_resword">desc</span>;
<span class="plsql_resword">begin</span>
   <span class="plsql_resword">for</span> <span class="plsql_userword">lr_rtr</span> <span class="plsql_resword">in</span> <span class="plsql_userword">fq_region_tax_rate</span><span class="plsql_brackets">(</span><span class="plsql_userword">is_tax_region</span>, <span class="plsql_userword">id_tax_date</span><span class="plsql_brackets">)</span> <span class="plsql_userword">loop</span>
      <span class="plsql_resword">return</span> <span class="plsql_userword">lr_rtr</span>.<span class="plsql_userword">n_tax_rate</span>;
   <span class="plsql_resword">end</span> <span class="plsql_userword">loop</span>;

   <span class="plsql_resword">return</span> <span class="plsql_resword">null</span>;
<span class="plsql_resword">end</span> <span class="plsql_userword">get_tax_rate</span>; </pre>
