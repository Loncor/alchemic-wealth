---
title: PL/SQL Naming Convention - Prefixes
layout: default
---
# Prefix Naming Convention

The [Naming Conventions](https://en.wikipedia.org/wiki/Naming_convention_(programming)) described here are based on the following aspects of an **Identifier** which are summarized in an identifier prefix.

## Scope

The [Scope](https://en.wikipedia.org/wiki/Scope_(computer_science)) of an Identifier in PL/SQL is decided by where it defined in the source code.

When you create an identifier, as listed below, the PL/SQL compiler will restrict references to that identifier. This means, for example, that a variable defined in one function will not be accessible in another function. To make it obvious where the identifier is defined, in this standard, a prefix is added to the name. For example **p** prefixes package body variables, **f** prefixes function variables and so on. These single character prefixes are detailed on the following web pages.

Code Block where Identifier is declared|Identifier Visibility
----------------- | ------------------------------
**Block declare section** | visible only within that **Block**.
**For loop index** or **record** | visible only within the **For loop**.
**Cursor parameters section** | visible only within the **Cursor**. With the exception of **Named Parameters** which allows the calling code to use the Parameter Names.
 **Functions and Procedures parameters section** | visible only within the **Function/Procedure**. With the exception of **Named Parameters** which allows the calling code to use the Parameter Names.
**Functions and Procedures declare section** | visible only within the **Function/Procedure**.
**Package specification declare section** | visible anywhere the package is visible.
**Package body declare section** | visible only within in the package body.
**Object Type specification** | visible wherever the object is visible.
**Object Type body declare section** | visible only within the **Object type body**.

For more information on scope see the [PL/SQL documentation](https://docs.oracle.com/cd/B28359_01/appdev.111/b28370/fundamentals.htm#CHDIIBEG).

## Data Types

Identifiers that are Variables or Constants will have a specified [Data type](https://en.wikipedia.org/wiki/Data_type). There are different data types, e.g. integers ro strings. In PL/SQL there are various types of data which are summerised below:-

Data Type Category|Description
----------------- | ------------------------------
**Scalar**|Only contains single values. For example **pls_integer** and **boolean**.
**Composite**|Composed of more that one data types. Each data type within a composite can be accessed individually. E.g. a **record** might contain a **number** and a **date**
**Reference**|This is a pointer to other types of data. E.g a **ref cursor** points to rows in a table.
**Large Object (LOB)**|This is a pointer to a large data object, which are stored seperately from other types of data.

## Identifier Types

In PL/SQL there are several types of identifiers. The following are the only ones that have will have a specific prefixes added to them.:-

Identifier Type     | Description
------------------- | ------------------------------------------------------------------
**Variable**        | Temporary Storage for data. Will be a specific Data Type.
**Constant**        | Immutable Temporary Storage for data. Will be a specific Data Type.
**Type definition** | Defines a Data Type (also includes Subtypes and Object Types)
