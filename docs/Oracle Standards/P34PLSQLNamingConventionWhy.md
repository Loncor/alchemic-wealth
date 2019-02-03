---
title: PL/SQL Naming Convention - Why?
layout: default
---
## Why have naming standards?

The key areas of benefit are **maintainability** and **trapping semantic errors**. These are seen to be improved because:-

*   Just by looking at the **Identifier name** the **Scope** of the **identifier** (Variable, Constant or Type) will be known.
*   The **Data type** will be known which will avoid errors created by coercion (implicit type conversion).
*   There will be **consistency** in the naming of identifiers.
*   One can easily **differentiate** between the **database column** and the program **variable** or **constant** within a SQL statement.
*   One can know if the field is a **Variable**, **Constant** or **Type** without looking at the declaration.
*   Identifiers will have a very **similar name** as the **database column** plus one or more prefixed letters.

## Other naming standard benefits.

The `%TYPE` attribute is often used in PL/SQL to obtain the data type of a column from a database table. This ensures the data type of the program variable always matches the data type of that column. However, this means the data type cannot be known unless one checks the databases **table.column** definition. As in the example below, say the data type of the column `color_code` is `varchar2(20)` by looking at the code below the developer does not know data type of the variable is a string. Using a standard prefix will aid the developer in this case.

<pre>color_code        sls_paints.color_code%type;</pre>

An additional benefit in having a prefix is that **temporary data items** will have a scope type in their prefix, **persistent data** items will only have the **data type** (if the [*Extended variation*](P8PLSQLNamingConventionExtended.html) is used). Oracle **reserved words** will have no prefix.

* {{layout.anote}} **Temporary data items** are variables or constants that **only** exist for the life of the executed code at the level they are defined (in other words the scope).
* {{layout.anote}}  **Database data items** have persistent data which does not vanish after the code has finished executing.

## Origin of this naming convention

This naming convention was derived from indirectly from the original [Hungarian Notation](https://en.wikipedia.org/wiki/Hungarian_notation). In that Wikipedia page there are a few famous proponents and opponents for this type of notation.
