## Identifier naming conventions for program data items or user-defined data types.

In this standard an **Identifier** (*variable*, *constant* or *user-defined data types*) will have a **prefix** of between **1 to 3 characters** followed by an **underscore**. This *{{ page.variation }}* naming convention will catergorise an **identifier's**:-

1.  **Scope,** which is the area of code where the identifier is visible and can be used. Additionally:-
	*   If the identifier is a parameter within a function (or procedure), it shows whether it is input, output or input-output.
	*   Also, if that part of the prefix is absent it indicates this is where the identifier was originally defined (e.g. a table column).
{% unless page.variation == 'Basic' %}
1.  **Data type** at a basic level of granulatiry (e.g. n_ is a number but could have any precision and scale). Additionally:-
	* This is the only part of the prefix that is **always present.**
{% if page.variation == 'Extended' %}
	* The naming convention is extended to the Database such that the **Data type** character will be prefixed to the **each column name** or **object attribute** etc. Neither the Scope or Identifier Type characters will never be required in the prefix. The scope will be considered as the **Original definition** and will have an unspecificed scope.
{% endif %}



{% endunless %}
1.  **Identifier type** which shows if the identifier is a constant, a data type definition or a variable (in which case this part of the prefix is absent).

{% if page.variation == 'Basic' %}
E.g The variable **f_cakes_eaten** is built as follows:-


Character 1 - Scope |Character 2 - type, constant or variable(null)|Underscore|Identifier
------------------- | ---------------------------- | -------- | ------------------------------------------
f|null| _ |cakes_eaten
|===========
{% else %}
E.g The constant **fi_cakes_eaten** is built as follows:-


Character 1 - Scope|Character 2 - Data type|Character 3 - type, constant or variable(null)|Underscore|Identifier
------------------ | -------------------- | ---------------------------- | -------- | ------------------------------------------
f|i|null| _ |cakes_eaten
|===========

{% endif %}


### Prefix rules by character position:-

#### **Scope** (level of visibility) or **Source** (the local of the original field definition).

First Character|Scope (level of visibility) or Source (the local of the original field definition).
---------- | ---------------------------------------------------------------------------------------
c|Is a **Cursor Input parameter**, visible only in the cursor.
f|Visible only within the **function** or **procedure** it is declared in.
g|Visible wherever **package** is available for use.
i|Is an **Input parameter** for Procedure or Function.
l|Visible only within the **block** or **for loop** it is declared in.
o|Is an **Output parameter** for Procedure or Function.
p|Visible anywhere within the **package body**. Defined in a package body.
u|Is an **Input/Output (Updatedable) parameter** for Procedure or Function.
|===========

{% unless page.variation == 'Basic' %}

#### **Data type** - type of data stored.

Next Character|Datatype - type of data stored.
---------- | ---------------------------------------------------------------------------------------
a|Arrays (known as collections in Oracle). Can be any of the types of collections available.
b|Boolean, stores logical values, which are TRUE, FALSE or NULL.
d|Oracle Date (which includes time down a second) or Timestamp (which includes fractions of a second).
e|User defined PL/SQL exception.
h|Uniform Resource Identifier (URI), can be any URIType, e.g. HTTPURIType, DBURIType,
i|Integer, can be either any of the allowed types of integer, e.g. PLS_INTEGER.
m|Money definition, it is suggested that you create a subtype for money, e.g. number(11,2).
n|Number definition that allows for decimal numbers. There are several types of data types that accept decimal numbers e.g. NUMBER, BINARY_FLOAT.
o|Object, which is an instantiated Object Type (similar to a Class in Java/C++).
q|Cursor - pointer to Query in SQL area. This has the result set of a SQL statement.
r|Record or Row Datatype, can be a from a cursor FOR LOOP or %ROWTYPE or via a Record Type.
s|String, can be a VARCHAR2 or any other string type.
u|BLOB or BFILE very large unstructured binary data object.
v|CLOB or NCLOB very large character object.
w|The Row ID of table row. Can be ROWID or UROWID.
x|XMLType, which contains useful methods to manipulate/interrogate XML.
|===========

{% endunless %}

#### **Identifier type** - Variable, Constant or Data Type

Next Character|Only to be used for creating a type/subtype, constant.
-------- | ---------------------------------------------------------------------------------------
|Indicates the identifier is a variable.
k|Indicates the identifier is a constant. If you are German this letter would make sense.
t|Indicates the identifier is not a data type but a data type definition.
|===========

#### Deduplication of variables

Next Character|Only used for de-duplication
-------- | ---------------------------------------------------------------------------------------
#|Use to de-duplicate the same variable name in sub-function.
|===========

## Identifiers that need no prefix

The following types of identifiers have no prefixes:-

*   **Labels** - these are defined in << >> brackets.
*   **Procedures** - whether or not it is inside a package or object type.
*   **Functions** - whether or not it is inside a package or object type.
*   **Packages** - name of a Package specification or body.
*   **Object Type** - name of a Object Type specification or body.

## Non-standard standards

There are always some rules that are over-ridden these are consessions:-

* **Package Specification constants**. - They can be considered to be a *Function*. This means they would come under that category. Variables would still follow the rules above. E.g.:-
{% highlight plsql %}
create package cakes is
	max_cakes_allowed       constant integer := 5;     -- Constant - no prefix as it is like a function;

{% if page.variation == 'Basic' %}
	g_total_cakes_eaten              integer := 0;     -- Variable - still has a prefix.
{% else %}
	gi_total_cakes_eaten             integer := 0;     -- Variable - still has a prefix
{% endif %}
end cakes;
{% endhighlight %}
* **Boolean Variables** - Sometimes, when using a Boolean variable an IF statement would look better without a prefix.
{% highlight plsql %}
if account_is_open then
   return recent_transactions;
end if;
{% endhighlight %}
