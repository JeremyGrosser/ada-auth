@Part(frontmatter, root="asis.msm")
@comment{$Source: e:\\cvsroot/ARM/ASIS/p-asis.mss,v $}
@comment{$Revision: 1.4 $ $Date: 2006/09/23 05:24:02 $}

@LabeledSection{package Asis}

@Chg{Version=[1],New=[The library package @RootLibUnit{ASIS}ASIS shall exist.
The package shall provide interfaces equivalent to those described in the
following subclauses.],
Old=[@f{@key[package] @RootLibUnit{ASIS}ASIS @key[is]}]}

Package Asis encapsulates implementation-specific declarations, which are
made available to ASIS and its client applications in an
implementation-independent manner.

Package Asis is the root of the ASIS interface.

Abstract

The Ada Semantic Interface Specification (ASIS) is an interface between an
Ada environment as defined by ISO/IEC 8652:1995 (the Ada Reference Manual)
and any tool requiring information from this environment. An Ada environment
includes valuable semantic and syntactic information. ASIS is an open and
published callable interface which gives CASE tool and application
developers access to this information. ASIS has been designed to be
independent of underlying Ada environment implementations, thus supporting
portability of software engineering tools while relieving tool developers
from having to understand the complexities of an Ada environment's
proprietary internal representation.
Package ASIS Types:

The following types are made visible directly through package Asis:
      type ASIS_Integer
      type ASIS_Natural
      type ASIS_Positive
      type List_Index
      type Context
      type Element
      type Element_List
      Element subtypes
      Element Kinds (set of enumeration types)
      type Compilation_Unit
      type Compilation_Unit_List
      Unit Kinds (set of enumeration types)
      type Traverse_Control
      subtype Program_Text

The ASIS interface uses string parameters for many procedure and function
calls. Wide_String is used to convey ASIS environment information.
Program_Text, a subtype of Wide_String, is used to convey program text.
The Ada type String is not used in the ASIS interface. Neither the Ada
types Character nor Wide_Character are used in the ASIS interface.

@Comment{Private parts don't belong in a standard!}
@ChgDeleted{Version=[1],Text=[Implementation_Defined types and values]}

@ChgDeleted{Version=[1],Text=[A number of implementation-defined types and constants are used. To make
the ASIS specification compile, the following types and constants are
provided:]}

@ChgDeleted{Version=[1],Text=[@f{@key[subtype] Implementation_Defined_Integer_Type @key[is] Integer;}@*
@f{Implementation_Defined_Integer_Constant : @key[constant] := 2**31-1;}]}

@ChgDeleted{Version=[1],Text=[In addition, there are several implementation-defined private types.
For compilation convenience these types have been represented as
enumeration types with the single value of "Implementation_Defined".
An implementation may define reasonable types and constants.
Please refer to commentary where each is used.]}


@LabeledClause{type ASIS_Integer}


    @b{subtype ASIS_Integer is Implementation_Defined_Integer_Type; }

A numeric subtype that allows each ASIS implementation to place constraints
on the lower and upper bounds. Whenever possible, the range of this type
should meet or exceed -(2**31-1) .. 2**31-1.

@LabeledClause{type ASIS_Natural}


    @b{subtype ASIS_Natural is ASIS_Integer range 0 .. ASIS_Integer'Last; }

@LabeledClause{type ASIS_Positive}


    @b{subtype ASIS_Positive is ASIS_Integer range 1 .. ASIS_Integer'Last; }

@LabeledClause{type List_Index }


    @b{List_Index_Implementation_Upper :
        constant ASIS_Positive := Implementation_Defined_Integer_Constant;
    subtype List_Index is ASIS_Positive
        range 1 .. List_Index_Implementation_Upper;}

List_Index is a numeric subtype used to establish the upper bound for list
size.
@LabeledClause{type Context }

The ASIS Context is a view of a particular implementation of an Ada
environment. ASIS requires an application to identify that view of
the Ada environment. An ASIS Context identifies an Ada environment
as defined by ISO/IEC 8652:1995. The Ada environment is well
defined for Ada implementations. ISO/IEC 8652:1995 provides for an
implementation-defined method to enter compilation units into the
Ada environment. Implementation permissions allow for illegal and
inconsistent units to be in the environment. The use of ASIS may
result in the exception ASIS_Failed being raised if the Ada
environment includes such units.

Defined by the implementation, an ASIS context is a way to identify
a set of Compilation Units to be processed by an ASIS application.
This may include things such as the pathname, search rules, etc.,
which are attributes of the Ada environment and consequently
becomes part of the ASIS Context only because it is a "view" of
the Ada environment.

Because the contents of the Ada environment are (Ada-)implementation
defined, the ASIS context may contain illegal compilation units.
An ASIS Context is a handle to a set of compilation units accessible
by an ASIS application. The set of compilation units available
from an ASIS context may be inconsistent, and may contain illegal
compilation units. The contents are selected from the Ada
environment as defined by the corresponding Ada Implementation.
ASIS should allow multiple open contexts.

In the Context abstraction, a logical handle is associated with Name and
Parameters values that are used by the implementation to identify and
connect to the information in the Ada environment.


An ASIS Context is associated with some set of Ada compilation units
maintained by an underlying Ada implementation or a stand-alone ASIS
implementation. After this association has been made, this set of units
is considered to be part of the compile-time Ada environment, which forms
the outermost context of any compilation, as specified in section 10.1.4 of
the Ada Reference Manual. This same environment context provides the
implicit outermost anonymous task during program execution.

Some implementations might not need explicit Name and/or Parameters values to
identify their Ada environment. Other implementations might choose to
implement the Ada environment as a single external file in which case the
name and parameters values might simply supply the Name, Form, and any other
values needed to open such a file.
Context shall be an undiscriminated limited private.

@begin{Example}
    @key[type] Context is limited private;
    Nil_Context : constant Context;}

    @key[function] "=" (Left  : in Context;
                  Right : in Context)
                  return Boolean is abstract;
@end{Example}

@b{Implementation Requirement}

The concrete mechanism of this association is implementation-specific:

Each ASIS implementation provides the means to construct an ASIS
Context value that defines the environment declarative_part or
"context" from which ASIS can obtain library units.

@LabeledClause{type Element}

The Ada lexical element abstraction (a private type).

The Element type is a distinct abstract type representing handles for the
lexical elements that form the text of compilation units. Elements deal
with the internal or "textual" view of compilation units.

Operations are provided that split a Compilation_Unit object into one
Element and two Element lists:

a) A context clause represented by an Element_List containing
   with clauses, use clauses, and pragmas.

b) An Element associated with the declaration.

c) A list of pragmas, that are not part of the context clause but which
   nonetheless affect the compilation of the unit.
ASIS Elements are representations of the syntactic and semantic information
available from most Ada environments.

The ASIS Element type shall be an undiscriminated private type.

@begin{Example}
    @key[type] Element is private;
    Nil_Element : constant Element;

    function "=" (Left  : in Element;
                  Right : in Element)
                  Return Boolean is abstract;
@end{Example}

@LabeledClause{type Element_List}

@begin{Example}
    @key[type] Element_List is array (List_Index range <>) of Element;

    Nil_Element_List : constant Element_List;
@end{Example}

@LabeledClause{subtypes of Element and Element_List }


    @b{subtype Access_Type_Definition          is Element;
    subtype Association                     is Element;
    subtype Association_List                is Element_List;
    subtype Case_Statement_Alternative      is Element;
    subtype Clause                          is Element;
    subtype Component_Clause                is Element;
    subtype Component_Clause_List           is Element_List;
    subtype Component_Declaration           is Element;
    subtype Component_Definition            is Element;
    subtype Constraint                      is Element;
    subtype Context_Clause                  is Element;
    subtype Context_Clause_List             is Element_List;
    subtype Declaration                     is Element;
    subtype Declaration_List                is Element_List;
    subtype Declarative_Item_List           is Element_List;
    subtype Definition                      is Element;
    subtype Definition_List                 is Element_List;
    subtype Discrete_Range                  is Element;
    subtype Discrete_Range_List             is Element_List;
    subtype Discrete_Subtype_Definition     is Element;
    subtype Discriminant_Association        is Element;
    subtype Discriminant_Association_List   is Element_List;
    subtype Discriminant_Specification_List is Element_List;
    subtype Defining_Name                   is Element;
    subtype Defining_Name_List              is Element_List;
    subtype Exception_Handler               is Element;
    subtype Exception_Handler_List          is Element_List;
    subtype Expression                      is Element;
    subtype Expression_List                 is Element_List;
    subtype Formal_Type_Definition          is Element;
    subtype Generic_Formal_Parameter        is Element;
    subtype Generic_Formal_Parameter_List   is Element_List;
    subtype Identifier                      is Element;
    subtype Identifier_List                 is Element_List;
    subtype Name                            is Element;
    subtype Name_List                       is Element_List;
    subtype Parameter_Specification         is Element;
    subtype Parameter_Specification_List    is Element_List;
    subtype Path                            is Element;
    subtype Path_List                       is Element_List;
    subtype Pragma_Element                  is Element;
    subtype Pragma_Element_List             is Element_List;
    subtype Range_Constraint                is Element;
    subtype Record_Component                is Element;
    subtype Record_Component_List           is Element_List;
    subtype Record_Definition               is Element;
    subtype Representation_Clause           is Element;
    subtype Representation_Clause_List      is Element_List;
    subtype Root_Type_Definition            is Element;
    subtype Select_Alternative              is Element;
    subtype Statement                       is Element;
    subtype Statement_List                  is Element_List;
    subtype Subtype_Indication              is Element;
    subtype Subtype_Mark                    is Element;
    subtype Type_Definition                 is Element;
    subtype Variant                         is Element;
    subtype Variant_Component_List          is Element_List;
    subtype Variant_List                    is Element_List;}

@LabeledClause{Element Kinds }

Element Kinds are enumeration types describing various kinds of elements.
These element kinds are only used by package Asis.Elements.

@LabeledSubClause{type Element_Kinds }

Element_Kinds Hierarchy

ASIS offers hierarchical classification of elements. At the highest
level, the Element_Kinds type provides literals that define "kinds" or
classes listed below into which all non-nil elements are grouped. Elements
in each of the Element_Kinds classes, with the exception of
An_Exception_Handler, can be further classified by a subordinate kind at
the next level in the hierarchy. Several subordinate kinds also have
additional subordinate kinds.

For example, Element_Kinds'A_Declaration might be classified into
Declaration_Kinds'A_Parameter_Specification which might be further
classified into Trait_Kinds'An_Access_Definition_Trait.
This fully identifies the syntax of an element such as:

      (Who : access Person)

All Element_Kinds and subordinate kinds Queries are in Asis.Elements.

It is not necessary to strictly follow the hierarchy; any element can be
classified by any subordinate kind from any level. However, meaningful
results will only be obtained from subordinate kinds that are appropriate.
These are designated within the hierarchy shown below:

       Element_Kinds         -> Subordinate Kinds

  Key: Read "->" as "is further classified by its"

       A_Pragma              -> Pragma_Kinds

       A_Defining_Name       -> Defining_Name_Kinds
                                        -> Operator_Kinds

       A_Declaration         -> Declaration_Kinds
                                        -> Trait_Kinds
                                        -> Declaration_Origins
                                        -> Mode_Kinds
                                        -> Subprogram_Default_Kinds

       A_Definition          -> Definition_Kinds
                                        -> Trait_Kinds
                                        -> Type_Kinds
                                                   -> Trait_Kinds
                                        -> Formal_Type_Kinds
                                                   -> Trait_Kinds
                                        -> Access_Type_Kinds
                                        -> Root_Type_Kinds
                                        -> Constraint_Kinds
                                        -> Discrete_Range_Kinds

       An_Expression         -> Expression_Kinds
                                        -> Operator_Kinds
                                        -> Attribute_Kinds

       An_Association        -> Association_Kinds

       A_Statement           -> Statement_Kinds

       A_Path                -> Path_Kinds

       A_Clause              -> Clause_Kinds
                                        -> Representation_Clause_Kinds

       An_Exception_Handler
Element_Kinds - general element classifications
Literals                   -- ASIS package with queries for these kinds

  @b{type Element_Kinds is (
    Not_An_Element,            -- Nil_Element
    A_Pragma,                  -- Asis.Elements
    A_Defining_Name,           -- Asis.Declarations
    A_Declaration,             -- Asis.Declarations
    A_Definition,              -- Asis.Definitions
    An_Expression,             -- Asis.Expressions
    An_Association,            -- Asis.Expressions
    A_Statement,               -- Asis.Statements
    A_Path,                    -- Asis.Statements
    A_Clause,                  -- Asis.Clauses
    An_Exception_Handler);     -- Asis.Statements}

@LabeledSubClause{type Pragma_Kinds}

Pragma_Kinds - classifications for pragmas
Literals                          -- Reference Manual

@begin{Example}
  @key[type] Pragma_Kinds is (

    Not_A_Pragma,                     -- An unexpected element
    An_All_Calls_Remote_Pragma,       -- E.2.3(5)
    An_Asynchronous_Pragma,           -- E.4.1(3)
    An_Atomic_Pragma,                 -- C.6(3)
    An_Atomic_Components_Pragma,      -- C.6(5)
    An_Attach_Handler_Pragma,         -- C.3.1(4)
    A_Controlled_Pragma,              -- 13.11.3(3)
    A_Convention_Pragma,              -- B.1(7), M.1(5)
    A_Discard_Names_Pragma,           -- C.5(3)
    An_Elaborate_Pragma,              -- 10.2.1(20)
    An_Elaborate_All_Pragma,          -- 10.2.1(21)
    An_Elaborate_Body_Pragma,         -- 10.2.1(22)
    An_Export_Pragma,                 -- B.1(5), M.1(5)
    An_Import_Pragma,                 -- B.1(6), M.1(5)
    An_Inline_Pragma,                 -- 6.3.2(3)
    An_Inspection_Point_Pragma,       -- H.3.2(3)
    An_Interrupt_Handler_Pragma,      -- C.3.1(2)
    An_Interrupt_Priority_Pragma,     -- D.1(5)
    A_Linker_Options_Pragma,          -- B.1(8)
    A_List_Pragma,                    -- 2.8(21)
    A_Locking_Policy_Pragma,          -- D.3(3)
    A_Normalize_Scalars_Pragma,       -- H.1(3)
    An_Optimize_Pragma,               -- 2.8(23)
    A_Pack_Pragma,                    -- 13.2(3)
    A_Page_Pragma,                    -- 2.8(22)
    A_Preelaborate_Pragma,            -- 10.2.1(3)
    A_Priority_Pragma,                -- D.1(3)
    A_Pure_Pragma,                    -- 10.2.1(14)
    A_Queuing_Policy_Pragma,          -- D.4(3)
    A_Remote_Call_Interface_Pragma,   -- E.2.3(3)
    A_Remote_Types_Pragma,            -- E.2.2(3)
    A_Restrictions_Pragma,            -- 13.12(3)
    A_Reviewable_Pragma,              -- H.3.1(3)
    A_Shared_Passive_Pragma,          -- E.2.1(3)
    A_Storage_Size_Pragma,            -- 13.3(63)
    A_Suppress_Pragma,                -- 11.5(4)
    A_Task_Dispatching_Policy_Pragma, -- D.2.2(2)
    A_Volatile_Pragma,                -- C.6(4)
    A_Volatile_Components_Pragma,     -- C.6(6)

    An_Implementation_Defined_Pragma, -- 2.8(14)

    An_Unknown_Pragma);               -- Unknown to ASIS
@end{Example}

@LabeledSubClause{type Defining_Name_Kinds }

Defining_Name_Kinds - names defined by declarations and specifications.
Literals                                   -- Reference Manual

@begin{Example}
  type Defining_Name_Kinds is (

    Not_A_Defining_Name,                       -- An unexpected element

    A_Defining_Identifier,                     -- 3.1(4)
    A_Defining_Character_Literal,              -- 3.5.1(4)
    A_Defining_Enumeration_Literal,            -- 3.5.1(3)
    A_Defining_Operator_Symbol,                -- 6.1(9)
    A_Defining_Expanded_Name);                 -- 6.1(7)
                                               -- program unit name defining_identifier
@end{Example}

@LabeledSubClause{type Declaration_Kinds }

Declaration_Kinds - declarations and specifications having defining name literals.
Literals                                 -- Reference Manual -> Subordinate Kinds

@begin{Example}
  type Declaration_Kinds is (

    Not_A_Declaration,                       -- An unexpected element

    An_Ordinary_Type_Declaration,            -- 3.2.1(3)}
@end{Example}

a full_type_declaration of the form:
type defining_identifier [known_discriminant_part] is type_definition;

@begin{Example}
    A_Task_Type_Declaration,                 -- 9.1(2)
    A_Protected_Type_Declaration,            -- 9.4(2)
    An_Incomplete_Type_Declaration,          -- 3.2.1(2),3.10(2)
    A_Private_Type_Declaration,              -- 3.2.1(2),7.3(2) -> Trait_Kinds
    A_Private_Extension_Declaration,         -- 3.2.1(2),7.3(3) -> Trait_Kinds

    A_Subtype_Declaration,                   -- 3.2.2(2)

    A_Variable_Declaration,                  -- 3.3.1(2) -> Trait_Kinds
    A_Constant_Declaration,                  -- 3.3.1(4) -> Trait_Kinds
    A_Deferred_Constant_Declaration,         -- 3.3.1(6),7.4(2) -> Trait_Kinds
    A_Single_Task_Declaration,               -- 3.3.1(2),9.1(3)
    A_Single_Protected_Declaration,          -- 3.3.1(2),9.4(2)

    An_Integer_Number_Declaration,           -- 3.3.2(2)
    A_Real_Number_Declaration,               -- 3.5.6(2)

    An_Enumeration_Literal_Specification,    -- 3.5.1(3)

    A_Discriminant_Specification,            -- 3.7(5)   -> Trait_Kinds
    A_Component_Declaration,                 -- 3.8(6)

    A_Loop_Parameter_Specification,          -- 5.5(4)   -> Trait_Kinds

    A_Procedure_Declaration,                 -- 6.1(4)   -> Trait_Kinds
    A_Function_Declaration,                  -- 6.1(4)   -> Trait_Kinds

    A_Parameter_Specification,               -- 6.1(15)  -> Trait_Kinds
                                             --          -> Mode_Kinds
    A_Procedure_Body_Declaration,            -- 6.3(2)
    A_Function_Body_Declaration,             -- 6.3(2)

    A_Package_Declaration,                   -- 7.1(2)
    A_Package_Body_Declaration,              -- 7.2(2)

    An_Object_Renaming_Declaration,          -- 8.5.1(2)
    An_Exception_Renaming_Declaration,       -- 8.5.2(2)
    A_Package_Renaming_Declaration,          -- 8.5.3(2)
    A_Procedure_Renaming_Declaration,        -- 8.5.4(2)
    A_Function_Renaming_Declaration,         -- 8.5.4(2)
    A_Generic_Package_Renaming_Declaration,  -- 8.5.5(2)
    A_Generic_Procedure_Renaming_Declaration,-- 8.5.5(2)
    A_Generic_Function_Renaming_Declaration, -- 8.5.5(2)

    A_Task_Body_Declaration,                 -- 9.1(6)
    A_Protected_Body_Declaration,            -- 9.4(7)
    An_Entry_Declaration,                    -- 9.5.2(2)
    An_Entry_Body_Declaration,               -- 9.5.2(5)
    An_Entry_Index_Specification,            -- 9.5.2(2)

    A_Procedure_Body_Stub,                   -- 10.1.3(3)
    A_Function_Body_Stub,                    -- 10.1.3(3)
    A_Package_Body_Stub,                     -- 10.1.3(4)
    A_Task_Body_Stub,                        -- 10.1.3(5)
    A_Protected_Body_Stub,                   -- 10.1.3(6)

    An_Exception_Declaration,                -- 11.1(2)
    A_Choice_Parameter_Specification,        -- 11.2(4)

    A_Generic_Procedure_Declaration,         -- 12.1(2)
    A_Generic_Function_Declaration,          -- 12.1(2)
    A_Generic_Package_Declaration,           -- 12.1(2)

    A_Package_Instantiation,                 -- 12.3(2)
    A_Procedure_Instantiation,               -- 12.3(2)
    A_Function_Instantiation,                -- 12.3(2)

    A_Formal_Object_Declaration,             -- 12.4(2)  -> Mode_Kinds
    A_Formal_Type_Declaration,               -- 12.5(2)
    A_Formal_Procedure_Declaration,          -- 12.6(2)  -> Subprogram_Default_Kinds
    A_Formal_Function_Declaration,           -- 12.6(2)  -> Subprogram_Default_Kinds
    A_Formal_Package_Declaration,            -- 12.7(2)
    A_Formal_Package_Declaration_With_Box);  -- 12.7(3)}
@end{Example}

The following Declaration_Kinds subtypes are not used by ASIS but are
provided for the convenience of the ASIS implementor:

@begin{Example}
  subtype A_Type_Declaration is Declaration_Kinds range
              An_Ordinary_Type_Declaration .. A_Private_Extension_Declaration;

  subtype A_Full_Type_Declaration is Declaration_Kinds range
              An_Ordinary_Type_Declaration .. A_Protected_Type_Declaration;

  subtype An_Object_Declaration is Declaration_Kinds range
              A_Variable_Declaration .. A_Single_Protected_Declaration;

  subtype A_Number_Declaration is Declaration_Kinds range
              An_Integer_Number_Declaration .. A_Real_Number_Declaration;

  subtype A_Renaming_Declaration is Declaration_Kinds range
              An_Object_Renaming_Declaration ..
              A_Generic_Function_Renaming_Declaration;

  subtype A_Body_Stub is Declaration_Kinds range
              A_Procedure_Body_Stub .. A_Protected_Body_Stub;

  subtype A_Generic_Declaration is Declaration_Kinds range
              A_Generic_Procedure_Declaration .. A_Generic_Package_Declaration;

  subtype A_Generic_Instantiation is Declaration_Kinds range
              A_Package_Instantiation .. A_Function_Instantiation;

  subtype A_Formal_Declaration is Declaration_Kinds range
              A_Formal_Object_Declaration ..
              A_Formal_Package_Declaration_With_Box;
@end{Example}

@LabeledSubClause{type Trait_Kinds }


Trait_Kinds provide a means of further classifying the syntactic structure
or "trait" of certain A_Declaration and A_Definition elements.
Trait_Kinds are determined only by the presence (or absence) of certain
reserved words. The semantics of an element are not considered.
The reserved words of interest here are "abstract", "aliased", "limited",
"private", "reverse", and "access" when it appears in an access_definition.
Trait_Kinds enumerates all combinations useful in this classification.

For example, A_Variable_Declaration element that is semantically a
limited type because its components are of a limited type is
An_Ordinary_Trait, not A_Limited_Trait, since the reserved word "limited"
does not appear in its declaration or definition.

The subordinate Trait_Kinds allow Declaration_Kinds and Definition_Kinds
to enumerate fewer higher level elements, and be less cluttered by all
possible permutations of syntactic possibilities. For example, in the case
of a record_type_definition, Definition_Kinds can provide just two literals
that differentiate between ordinary record types and tagged record types:

    A_Record_Type_Definition,              -- 3.8(2)    -> Trait_Kinds
    A_Tagged_Record_Type_Definition,       -- 3.8(2)    -> Trait_Kinds

The remaining classification can be accomplished, if desired, using
Trait_Kinds to determine if the definition is abstract, or limited, or both.
Without Trait_Kinds, Definition_Kinds needs six literals to identify
all the syntactic combinations for a record_type_definition.

Elements expected by the Trait_Kind query are any Declaration_Kinds or
Definition_Kinds for which Trait_Kinds is a subordinate kind: the literal
definition has "-> Trait_Kinds" following it. For example, the
definitions of:

    A_Discriminant_Specification,              -- 3.7(5)   -> Trait_Kinds
    A_Component_Declaration,                   -- 3.8(6)

indicate A_Discriminant_Specification is an expected kind while
A_Component_Declaration is unexpected.

All Declaration_Kinds and Definition_Kinds for which Trait_Kinds is not a
subordinate kind, and all other Element_Kinds, are unexpected and are
Not_A_Trait.

An_Ordinary_Trait is any expected element whose syntax does not explicitly
contain any of the reserved words listed above.



Trait_Kinds
Literals

@begin{Example}
  type Trait_Kinds is (

    Not_A_Trait,                         -- An unexpected element

    An_Ordinary_Trait,                   -- The declaration or definition does
                                         -- not contain the reserved words
                                         -- "aliased", "reverse", "private",
                                         -- "limited", "abstract", or
                                         -- "access" in an access_definition

    An_Aliased_Trait,                    -- "aliased" is present
    An_Access_Definition_Trait,          -- "access" in an access_definition is present
    A_Reverse_Trait,                     -- "reverse" is present
    A_Private_Trait,                     -- Only "private" is present
    A_Limited_Trait,                     -- Only "limited" is present
    A_Limited_Private_Trait,             -- "limited" and "private" are present

    An_Abstract_Trait,                   -- Only "abstract" is present
    An_Abstract_Private_Trait,           -- "abstract" and "private" are present
    An_Abstract_Limited_Trait,           -- "abstract" and "limited" are present
    An_Abstract_Limited_Private_Trait);  -- "abstract", "limited", and "private" are
                                         -- present
@end{Example}

@LabeledSubClause{type Declaration_Origins }

Declaration_Origins
Literals                             -- Reference Manual

@begin{Example}
  type Declaration_Origins is (

    Not_A_Declaration_Origin,            -- An unexpected element

    An_Explicit_Declaration,             -- 3.1(5) explicitly declared in
                                         -- the text of a program, or within
                                         -- an expanded generic template
    An_Implicit_Predefined_Declaration,  -- 3.1(5), 3.2.3(1), A.1(2)
    An_Implicit_Inherited_Declaration);  -- 3.1(5), 3.4(6-35)
@end{Example}

@LabeledSubClause{type Mode_Kinds }

Mode_Kinds
Literals                 -- Reference Manual

@begin{Example}
  type Mode_Kinds is (       -- 6.1

    Not_A_Mode,              -- An unexpected element

    A_Default_In_Mode,       -- procedure A(B :        C);
    An_In_Mode,              -- procedure A(B : IN     C);
    An_Out_Mode,             -- procedure A(B :    OUT C);
    An_In_Out_Mode);         -- procedure A(B : IN OUT C);
@end{Example}

@LabeledSubClause{type Subprogram_Default_Kinds }

Subprogram_Default_Kinds
Literals                 -- Reference Manual

@begin{Example}
  type Subprogram_Default_Kinds is (    -- 12.6

    Not_A_Default,           -- An unexpected element

    A_Name_Default,          -- with subprogram_specification is default_name;
    A_Box_Default,           -- with subprogram_specification is <>;
    A_Nil_Default);          -- with subprogram_specification;
@end{Example}


@LabeledSubClause{type Definition_Kinds }

Definition_Kinds
Literals                          -- Reference Manual   -> Subordinate Kinds

@begin{Example}
  type Definition_Kinds is (

    Not_A_Definition,                 -- An unexpected element

    A_Type_Definition,                -- 3.2.1(4)    -> Type_Kinds

    A_Subtype_Indication,             -- 3.2.2(3)
    A_Constraint,                     -- 3.2.2(5)    -> Constraint_Kinds

    A_Component_Definition,           -- 3.6(7)      -> Trait_Kinds

    A_Discrete_Subtype_Definition,    -- 3.6(6)      -> Discrete_Range_Kinds
    A_Discrete_Range,                 -- 3.6.1(3)    -> Discrete_Range_Kinds

    An_Unknown_Discriminant_Part,     -- 3.7(3)
    A_Known_Discriminant_Part,        -- 3.7(2)

    A_Record_Definition,              -- 3.8(3)
    A_Null_Record_Definition,         -- 3.8(3)

    A_Null_Component,                 -- 3.8(4)
    A_Variant_Part,                   -- 3.8.1(2)
    A_Variant,                        -- 3.8.1(3)

    An_Others_Choice,                 -- 3.8.1(5), 4.3.1(5), 4.3.3(5), 11.2(5)

    A_Private_Type_Definition,        -- 7.3(2)      -> Trait_Kinds
    A_Tagged_Private_Type_Definition, -- 7.3(2)      -> Trait_Kinds
    A_Private_Extension_Definition,   -- 7.3(3)      -> Trait_Kinds

    A_Task_Definition,                -- 9.1(4)
    A_Protected_Definition,           -- 9.4(4)

    A_Formal_Type_Definition);        -- 12.5(3)     -> Formal_Type_Kinds
@end{Example}

@LabeledSubClause{type Type_Kinds}

Type_Kinds
Literals                               -- Reference Manual  -> Subordinate Kinds

@begin{Example}
  type Type_Kinds is (

    Not_A_Type_Definition,                 -- An unexpected element

    A_Derived_Type_Definition,             -- 3.4(2)     -> Trait_Kinds
    A_Derived_Record_Extension_Definition, -- 3.4(2)     -> Trait_Kinds

    An_Enumeration_Type_Definition,        -- 3.5.1(2)

    A_Signed_Integer_Type_Definition,      -- 3.5.4(3)
    A_Modular_Type_Definition,             -- 3.5.4(4)

    A_Root_Type_Definition,                -- 3.5.4(14), 3.5.6(3)
                                           --        -> Root_Type_Kinds
    A_Floating_Point_Definition,           -- 3.5.7(2)

    An_Ordinary_Fixed_Point_Definition,    -- 3.5.9(3)
    A_Decimal_Fixed_Point_Definition,      -- 3.5.9(6)

    An_Unconstrained_Array_Definition,     -- 3.6(2)
    A_Constrained_Array_Definition,        -- 3.6(2)

    A_Record_Type_Definition,              -- 3.8(2)     -> Trait_Kinds
    A_Tagged_Record_Type_Definition,       -- 3.8(2)     -> Trait_Kinds

    An_Access_Type_Definition);            -- 3.10(2)    -> Access_Type_Kinds
@end{Example}

@LabeledSubClause{type Formal_Type_Kinds }

Formal_Type_Kinds
Literals                                  -- Reference Manual  -> Subordinate Kinds

@begin{Example}
  type Formal_Type_Kinds is (

    Not_A_Formal_Type_Definition,             -- An unexpected element

    A_Formal_Private_Type_Definition,         -- 12.5.1(2)   -> Trait_Kinds
    A_Formal_Tagged_Private_Type_Definition,  -- 12.5.1(2)   -> Trait_Kinds

    A_Formal_Derived_Type_Definition,         -- 12.5.1(3)   -> Trait_Kinds

    A_Formal_Discrete_Type_Definition,        -- 12.5.2(2)

    A_Formal_Signed_Integer_Type_Definition,  -- 12.5.2(3)
    A_Formal_Modular_Type_Definition,         -- 12.5.2(4)

    A_Formal_Floating_Point_Definition,       -- 12.5.2(5)

    A_Formal_Ordinary_Fixed_Point_Definition, -- 12.5.2(6)
    A_Formal_Decimal_Fixed_Point_Definition,  -- 12.5.2(7)

    A_Formal_Unconstrained_Array_Definition,  -- 3.6(3)
    A_Formal_Constrained_Array_Definition,    -- 3.6(5)

    A_Formal_Access_Type_Definition);         -- 3.10(3),3.10(5)
                                              --         -> Access_Type_Kinds
@end{Example}

@LabeledSubClause{type Access_Type_Kinds }

Access_Type_Kinds
Literals                             -- Reference Manual

@begin{Example}
  type Access_Type_Kinds is ( 3.10

    Not_An_Access_Type_Definition,       -- An unexpected element

    A_Pool_Specific_Access_To_Variable,  -- access subtype_indication
    An_Access_To_Variable,               -- access all subtype_indication
    An_Access_To_Constant,               -- access constant subtype_indication

    An_Access_To_Procedure,              -- access procedure
    An_Access_To_Protected_Procedure,    -- access protected procedure
    An_Access_To_Function,               -- access function
    An_Access_To_Protected_Function);    -- access protected function
@end{Example}

The following Access_Type_Kinds subtypes are not used by ASIS but are
provided for the convenience of the ASIS implementor:

@begin{Example}
  subtype Access_To_Object_Definition is Access_Type_Kinds range
            A_Pool_Specific_Access_To_Variable .. An_Access_To_Constant;

  subtype Access_To_Subprogram_Definition is Access_Type_Kinds range
            An_Access_To_Procedure .. An_Access_To_Protected_Function;
@end{Example}

@LabeledSubClause{type Root_Type_Kinds}

Root_Type_Kinds
Literals                               -- Reference Manual

@begin{Example}
  type Root_Type_Kinds is (

    Not_A_Root_Type_Definition,            -- An unexpected element

    A_Root_Integer_Definition,             -- 3.4.1(8)
    A_Root_Real_Definition,                -- 3.4.1(8)

    A_Universal_Integer_Definition,        -- 3.4.1(6)
    A_Universal_Real_Definition,           -- 3.4.1(6)
    A_Universal_Fixed_Definition);         -- 3.4.1(6)
@end{Example}

@LabeledSubClause{type Constraint_Kinds}

Constraint_Kinds
Literals                               -- Reference Manual

@begin{Example}
  type Constraint_Kinds is (

    Not_A_Constraint,                      -- An unexpected element

    A_Range_Attribute_Reference,           -- 3.5(2)
    A_Simple_Expression_Range,             -- 3.2.2, 3.5(3)
    A_Digits_Constraint,                   -- 3.2.2, 3.5.9
    A_Delta_Constraint,                    -- 3.2.2, J.3
    An_Index_Constraint,                   -- 3.2.2, 3.6.1
    A_Discriminant_Constraint);            -- 3.2.2
@end{Example}

@LabeledSubClause{type Discrete_Range_Kinds}

Discrete_Range_Kinds
Literals                               -- Reference Manual

@begin{Example}
  type Discrete_Range_Kinds is (

    Not_A_Discrete_Range,                  -- An unexpected element

    A_Discrete_Subtype_Indication,         -- 3.6.1(6), 3.2.2
    A_Discrete_Range_Attribute_Reference,  -- 3.6.1, 3.5
    A_Discrete_Simple_Expression_Range);   -- 3.6.1, 3.5
@end{Example}

@LabeledSubClause{type Association_Kinds}

Association_Kinds
Literals                               -- Reference Manual

@begin{Example}
  type Association_Kinds is (

    Not_An_Association,                    -- An unexpected element

    A_Pragma_Argument_Association,         -- 2.8
    A_Discriminant_Association,            -- 3.7.1
    A_Record_Component_Association,        -- 4.3.1
    An_Array_Component_Association,        -- 4.3.3
    A_Parameter_Association,               -- 6.4
    A_Generic_Association);                -- 12.3
@end{Example}

@LabeledSubClause{type Expression_Kinds}


Expression_Kinds - general expression classifications
Literals                                   -- Reference Manual -> Subordinate Kinds

@begin{Example}
  type Expression_Kinds is (

    Not_An_Expression,                         -- An unexpected element

    An_Integer_Literal,                        -- 2.4
    A_Real_Literal,                            -- 2.4.1
    A_String_Literal,                          -- 2.6

    An_Identifier,                             -- 4.1
    An_Operator_Symbol,                        -- 4.1
    A_Character_Literal,                       -- 4.1
    An_Enumeration_Literal,                    -- 4.1
    An_Explicit_Dereference,                   -- 4.1
    A_Function_Call,                           -- 4.1

    An_Indexed_Component,                      -- 4.1.1
    A_Slice,                                   -- 4.1.2
    A_Selected_Component,                      -- 4.1.3
    An_Attribute_Reference,                    -- 4.1.4  -> Attribute_Kinds

    A_Record_Aggregate,                        -- 4.3
    An_Extension_Aggregate,                    -- 4.3
    A_Positional_Array_Aggregate,              -- 4.3
    A_Named_Array_Aggregate,                   -- 4.3

    An_And_Then_Short_Circuit,                 -- 4.4
    An_Or_Else_Short_Circuit,                  -- 4.4

    An_In_Range_Membership_Test,               -- 4.4
    A_Not_In_Range_Membership_Test,            -- 4.4
    An_In_Type_Membership_Test,                -- 4.4
    A_Not_In_Type_Membership_Test,             -- 4.4

    A_Null_Literal,                            -- 4.4
    A_Parenthesized_Expression,                -- 4.4

    A_Type_Conversion,                         -- 4.6
    A_Qualified_Expression,                    -- 4.7

    An_Allocation_From_Subtype,                -- 4.8
    An_Allocation_From_Qualified_Expression);  -- 4.8
@end{Example}

@LabeledSubClause{type Operator_Kinds}

Operator_Kinds - classification of the various Ada predefined operators
Literals                           -- Reference Manual

@begin{Example}
  type Operator_Kinds is (             -- 4.5

    Not_An_Operator,                   -- An unexpected element

    An_And_Operator,                   -- and
    An_Or_Operator,                    -- or
    An_Xor_Operator,                   -- xor
    An_Equal_Operator,                 -- =
    A_Not_Equal_Operator,              -- /=
    A_Less_Than_Operator,              -- <
    A_Less_Than_Or_Equal_Operator,     -- <=
    A_Greater_Than_Operator,           -- >
    A_Greater_Than_Or_Equal_Operator,  -- >=
    A_Plus_Operator,                   -- +
    A_Minus_Operator,                  -- -
    A_Concatenate_Operator,            -- &
    A_Unary_Plus_Operator,             -- +
    A_Unary_Minus_Operator,            -- -
    A_Multiply_Operator,               -- *
    A_Divide_Operator,                 -- /
    A_Mod_Operator,                    -- mod
    A_Rem_Operator,                    -- rem
    An_Exponentiate_Operator,          -- **
    An_Abs_Operator,                   -- abs
    A_Not_Operator);                   -- not
@end{Example}

@LabeledSubClause{type Attribute_Kinds }

Attribute_Kinds - classifications for all known Ada attributes
Literals                       -- Reference Manual

@begin{Example}
  type Attribute_Kinds is (

    Not_An_Attribute,              -- An unexpected element

    An_Access_Attribute,           -- 3.10.2(24), 3.10.2(32), K(2), K(4)
    An_Address_Attribute,          -- 13.3(11), J.7.1(5), K(6)
    An_Adjacent_Attribute,         -- A.5.3(48), K(8)
    An_Aft_Attribute,              -- 3.5.10(5), K(12)
    An_Alignment_Attribute,        -- 13.3(23), K(14)
    A_Base_Attribute,              -- 3.5(15), K(17)
    A_Bit_Order_Attribute,         -- 13.5.3(4), K(19)
    A_Body_Version_Attribute,      -- E.3(4), K(21)
    A_Callable_Attribute,          -- 9.9(2), K(23)
    A_Caller_Attribute,            -- C.7.1(14), K(25)
    A_Ceiling_Attribute,           -- A.5.3(33), K(27)
    A_Class_Attribute,             -- 3.9(14), 7.3.1(9), K(31), K(34)
    A_Component_Size_Attribute,    -- 13.3(69), K(36)
    A_Compose_Attribute,           -- A.5.3(24), K(38)
    A_Constrained_Attribute,       -- 3.7.2(3), J.4(2), K(42)
    A_Copy_Sign_Attribute,         -- A.5.3(51), K(44)
    A_Count_Attribute,             -- 9.9(5), K(48)
    A_Definite_Attribute,          -- 12.5.1(23), K(50)
    A_Delta_Attribute,             -- 3.5.10(3), K(52)
    A_Denorm_Attribute,            -- A.5.3(9), K(54)
    A_Digits_Attribute,            -- 3.5.8(2), 3.5.10(7), K(56), K(58)
    An_Exponent_Attribute,         -- A.5.3(18), K(60)
    An_External_Tag_Attribute,     -- 13.3(75), K(64)
    A_First_Attribute,             -- 3.5(12), 3.6.2(3), K(68), K(70)
    A_First_Bit_Attribute,         -- 13.5.2(3), K(72)
    A_Floor_Attribute,             -- A.5.3(30), K(74)
    A_Fore_Attribute,              -- 3.5.10(4), K(78)
    A_Fraction_Attribute,          -- A.5.3(21), K(80)
    An_Identity_Attribute,         -- 11.4.1(9), C.7.1(12), K(84), K(86)
    An_Image_Attribute,            -- 3.5(35), K(88)
    An_Input_Attribute,            -- 13.13.2(22), 13.13.2(32), K(92), K(96)
    A_Last_Attribute,              -- 3.5(13), 3.6.2(5), K(102), K(104)
    A_Last_Bit_Attribute,          -- 13.5.2(4), K(106)
    A_Leading_Part_Attribute,      -- A.5.3(54), K(108)
    A_Length_Attribute,            -- 3.6.2(9), K(117)
    A_Machine_Attribute,           -- A.5.3(60), K(119)
    A_Machine_Emax_Attribute,      -- A.5.3(8), K(123)
    A_Machine_Emin_Attribute,      -- A.5.3(7), K(125)
    A_Machine_Mantissa_Attribute,  -- A.5.3(6), K(127)
    A_Machine_Overflows_Attribute, -- A.5.3(12), A.5.4(4), K(129), K(131)
    A_Machine_Radix_Attribute,     -- A.5.3(2), A.5.4(2), K(133), K(135)
    A_Machine_Rounds_Attribute,    -- A.5.3(11), A.5.4(3), K(137), K(139)
    A_Max_Attribute,               -- 3.5(19), K(141)
    A_Max_Size_In_Storage_Elements_Attribute,--  13.11.1(3), K(145)
    A_Min_Attribute,               -- 3.5(16), K(147)
    A_Model_Attribute,             -- A.5.3(68), G.2.2(7), K(151)
    A_Model_Emin_Attribute,        -- A.5.3(65), G.2.2(4), K(155)
    A_Model_Epsilon_Attribute,     -- A.5.3(66), K(157)
    A_Model_Mantissa_Attribute,    -- A.5.3(64), G.2.2(3), K(159)
    A_Model_Small_Attribute,       -- A.5.3(67), K(161)
    A_Modulus_Attribute,           -- 3.5.4(17), K(163)
    An_Output_Attribute,           -- 13.13.2(19), 13.13.2(29), K(165), K(169)
    A_Partition_ID_Attribute,      -- E.1(9), K(173)
    A_Pos_Attribute,               -- 3.5.5(2), K(175)
    A_Position_Attribute,          -- 13.5.2(2), K(179)
    A_Pred_Attribute,              -- 3.5(25), K(181)
    A_Range_Attribute,             -- 3.5(14), 3.6.2(7), K(187), K(189)
    A_Read_Attribute,              -- 13.13.2(6), 13.13.2(14), K(191), K(195)
    A_Remainder_Attribute,         -- A.5.3(45), K(199)
    A_Round_Attribute,             -- 3.5.10(12), K(203)
    A_Rounding_Attribute,          -- A.5.3(36), K(207)
    A_Safe_First_Attribute,        -- A.5.3(71), G.2.2(5), K(211)
    A_Safe_Last_Attribute,         -- A.5.3(72), G.2.2(6), K(213)
    A_Scale_Attribute,             -- 3.5.10(11), K(215)
    A_Scaling_Attribute,           -- A.5.3(27), K(217)
    A_Signed_Zeros_Attribute,      -- A.5.3(13), K(221)
    A_Size_Attribute,              -- 13.3(40), 13.3(45), K(223), K(228)
    A_Small_Attribute,             -- 3.5.10(2), K(230)
    A_Storage_Pool_Attribute,      -- 13.11(13), K(232)
    A_Storage_Size_Attribute,      -- 13.3(60), 13.11(14), J.9(2), K(234),
                                      -- K(236)
    A_Succ_Attribute,              -- 3.5(22), K(238)
    A_Tag_Attribute,               -- 3.9(16), 3.9(18), K(242), K(244)
    A_Terminated_Attribute,        -- 9.9(3), K(246)
    A_Truncation_Attribute,        -- A.5.3(42), K(248)
    An_Unbiased_Rounding_Attribute,-- A.5.3(39), K(252)
    An_Unchecked_Access_Attribute, -- 13.10(3), H.4(18), K(256)
    A_Val_Attribute,               -- 3.5.5(5), K(258)
    A_Valid_Attribute,             -- 13.9.2(3), H(6), K(262)
    A_Value_Attribute,             -- 3.5(52), K(264)
    A_Version_Attribute,           -- E.3(3), K(268)
    A_Wide_Image_Attribute,        -- 3.5(28), K(270)
    A_Wide_Value_Attribute,        -- 3.5(40), K(274)
    A_Wide_Width_Attribute,        -- 3.5(38), K(278)
    A_Width_Attribute,             -- 3.5(39), K(280)
    A_Write_Attribute,             -- 13.13.2(3), 13.13.2(11), K(282), K(286)

    An_Implementation_Defined_Attribute,  -- Reference Manual, Annex M
    An_Unknown_Attribute);         -- Unknown to ASIS
@end{Example}

@LabeledSubClause{type Statement_Kinds }

Statement_Kinds - classifications of Ada statements
Literals                             -- Reference Manual

@begin{Example}
  type Statement_Kinds is (

    Not_A_Statement,                     -- An unexpected element

    A_Null_Statement,                    -- 5.1
    An_Assignment_Statement,             -- 5.2
    An_If_Statement,                     -- 5.3
    A_Case_Statement,                    -- 5.4

    A_Loop_Statement,                    -- 5.5
    A_While_Loop_Statement,              -- 5.5
    A_For_Loop_Statement,                -- 5.5
    A_Block_Statement,                   -- 5.6
    An_Exit_Statement,                   -- 5.7
    A_Goto_Statement,                    -- 5.8

    A_Procedure_Call_Statement,          -- 6.4
    A_Return_Statement,                  -- 6.5

    An_Accept_Statement,                 -- 9.5.2
    An_Entry_Call_Statement,             -- 9.5.3

    A_Requeue_Statement,                 -- 9.5.4
    A_Requeue_Statement_With_Abort,      -- 9.5.4

    A_Delay_Until_Statement,             -- 9.6
    A_Delay_Relative_Statement,          -- 9.6

    A_Terminate_Alternative_Statement,   -- 9.7.1
    A_Selective_Accept_Statement,        -- 9.7.1
    A_Timed_Entry_Call_Statement,        -- 9.7.2
    A_Conditional_Entry_Call_Statement,  -- 9.7.3
    An_Asynchronous_Select_Statement,    -- 9.7.4

    An_Abort_Statement,                  -- 9.8
    A_Raise_Statement,                   -- 11.3
    A_Code_Statement);                   -- 13.8
@end{Example}

@LabeledSubClause{type Path_Kinds}


A_Path elements represent execution path alternatives presented by the
if_statement, case_statement, and the four forms of select_statement.
Each statement path alternative encloses component elements that
represent a sequence_of_statements. Some forms of A_Path elements also
have as a component elements that represent a condition, an optional
guard, or a discrete_choice_list.

ASIS treats the select_alternative, entry_call_alternative, and
triggering_alternative, as the syntactic equivalent of a
sequence_of_statements. Specifically, the terminate_alternative (terminate;)
is treated as the syntactical equivalent of a single statement and are
represented as Statement_Kinds'A_Terminate_Alternative_Statement.
This allows queries to directly provide the sequence_of_statements enclosed
by A_Path elements, avoiding the extra step of returning an element
representing such an alternative.

For example,

@begin{Example}
    select   -- A_Select_Path enclosing a sequence of two statements

      accept Next_Work_Item(WI : in Work_Item) do
        Current_Work_Item := WI;
      end;
      Process_Work_Item(Current_Work_Item);

    or       -- An_Or_Path enclosing a guard and a sequence of two statements

      when Done_Early =>
        accept Shut_Down;
        exit;

    or       -- An_Or_Path enclosing a sequence with only a single statement

      terminate;

    end select;
@end{Example}

Path_Kinds
Literals                      -- Reference Manual

@begin{Example}
  type Path_Kinds is (

    Not_A_Path,                   -- An unexpected element

    An_If_Path,                   -- 5.3:
                                        -- if condition then
                                        --   sequence_of_statements

    An_Elsif_Path,                -- 5.3:
                                        -- elsif condition then
                                        --   sequence_of_statements

    An_Else_Path,                 -- 5.3, 9.7.1, 9.7.3:
                                        -- else sequence_of_statements

    A_Case_Path,                  -- 5.4:
                                        -- when discrete_choice_list =>
                                        --   sequence_of_statements

    A_Select_Path,                -- 9.7.1:
                                        -- select [guard] select_alternative
                                        -- 9.7.2, 9.7.3:
                                        -- select entry_call_alternative
                                        -- 9.7.4:
                                        -- select triggering_alternative

    An_Or_Path,                   -- 9.7.1:
                                        -- or [guard] select_alternative
                                  -- 9.7.2:
                                        -- or delay_alternative

    A_Then_Abort_Path);           -- 9.7.4
                                        -- then abort sequence_of_statements
@end{Example}

@LabeledSubClause{type Clause_Kinds }

Clause_Kinds
Literals                      -- Reference Manual    -> Subordinate Kinds

@begin{Example}
  type Clause_Kinds is (

    Not_A_Clause,                 -- An unexpected element

    A_Use_Package_Clause,         -- 8.4
    A_Use_Type_Clause,            -- 8.4

    A_With_Clause,                -- 10.1.2

    A_Representation_Clause,      -- 13.1     -> Representation_Clause_Kinds
    A_Component_Clause);          -- 13.5.1
@end{Example}

@LabeledSubClause{type Representation_Clause_Kinds }

Representation_Clause_Kinds - varieties of representation clauses
Literals                                  -- Reference Manual

@begin{Example}
  type Representation_Clause_Kinds is (

    Not_A_Representation_Clause,              -- An unexpected element

    An_Attribute_Definition_Clause,           -- 13.3
    An_Enumeration_Representation_Clause,     -- 13.4
    A_Record_Representation_Clause,           -- 13.5.1
    An_At_Clause);                            -- J.7
@end{Example}

@LabeledClause{type Compilation_Unit}

The Ada Compilation Unit abstraction:

The text of a program is submitted to the compiler in one or more
compilations. Each compilation is a succession of compilation units.

Compilation units are composed of three distinct parts:

a) A context clause.

b) The declaration of a library_item or unit.

c) Pragmas that apply to the compilation, of which the unit is a part.

The context clause contains zero or more with clauses, use clauses,
pragma elaborates, and possibly other pragmas.

ASIS treats Pragmas that appear immediately after the context clause and before
before the subsequent declaration part as belonging to the context clause part.

The declaration associated with a compilation unit is one of: a
package, a procedure, a function, a generic, or a subunit for normal units.
The associated declaration is a Nil_Element for An_Unknown_Unit and
Nonexistent units.

The abstract type Compilation_Unit is a handle for compilation units as a
whole. An object of the type Compilation_Unit deals with the external view
of compilation units such as their relationships with other units or their
compilation attributes.

Compilation_Unit shall be an undiscriminated private type.

@begin{Example}
    type Compilation_Unit is private;
    Nil_Compilation_Unit : constant Compilation_Unit;

    function "=" (Left  : in Compilation_Unit;
                  Right : in Compilation_Unit)
                  Return Boolean is abstract;
@end{Example}


@LabeledClause{type Compilation_Unit_List}

@begin{Example}
@key[type] @AdaTypeDefn{Compilation_Unit_List} @key[is]
       @key[array] (List_Index @key[range] <>) @key[of] Compilation_Unit;

@AdaObjDefn{Nil_Compilation_Unit_Lis}t : @key[constant] Compilation_Unit_List;
@end{Example}


@LabeledClause{Unit Kinds}

Unit Kinds@Defn{Unit kinds} are enumeration types describing the various kinds of units.
These element kinds are only used by package Asis.Compilation_Units.


@LabeledSubClause{type Unit_Kinds}

Unit_Kinds @Chg{Version=[1],New=[defines],Old=[@en]} the varieties of compilation units of compilations,
including compilations having no compilation units but consisting of
configuration pragmas or comments.

@begin{Example}
@key[type] @AdaTypeDefn{Unit_Kinds} @key[is] (

   @AdaObjDefn{Not_A_Unit},                  -- A Nil_Compilation_Unit

   @AdaObjDefn{A_Procedure},
   @AdaObjDefn{A_Function},
   @AdaObjDefn{A_Package},

   @AdaObjDefn{A_Generic_Procedure},
   @AdaObjDefn{A_Generic_Function},
   @AdaObjDefn{A_Generic_Package},

   @AdaObjDefn{A_Procedure_Instance},
   @AdaObjDefn{A_Function_Instance},
   @AdaObjDefn{A_Package_Instance},

   @AdaObjDefn{A_Procedure_Renaming},
   @AdaObjDefn{A_Function_Renaming},
   @AdaObjDefn{A_Package_Renaming},

   @AdaObjDefn{A_Generic_Procedure_Renaming},
   @AdaObjDefn{A_Generic_Function_Renaming},
   @AdaObjDefn{A_Generic_Package_Renaming},

   @AdaObjDefn{A_Procedure_Body},    -- A unit interpreted only as the completion
                        -- of a procedure, or a unit interpreted as
                        -- both the declaration and body of a library
                        -- procedure. Reference Manual 10.1.4(4)

   @AdaObjDefn{A_Function_Body},     -- A unit interpreted only as the completion
                        -- of a function, or a unit interpreted as
                        -- both the declaration and body of a library
                        -- function. Reference Manual 10.1.4(4)

   @AdaObjDefn{A_Package_Body},

   @AdaObjDefn{A_Procedure_Body_Subunit},
   @AdaObjDefn{A_Function_Body_Subunit},
   @AdaObjDefn{A_Package_Body_Subunit},
   @AdaObjDefn{A_Task_Body_Subunit},
   @AdaObjDefn{A_Protected_Body_Subunit},

   @AdaObjDefn{A_Nonexistent_Declaration},   -- A unit that does not exist but is:
                                -- 1) mentioned in a with clause of
                                --    another unit or,
                                -- 2) a required corresponding
                                --    library_unit_declaration

   @AdaObjDefn{A_Nonexistent_Body},          -- A unit that does not exist but is:
                                -- 1) known to be a corresponding
                                --    subunit or,
                                -- 2) a required corresponding
                                --    library_unit_body

   @AdaObjDefn{A_Configuration_Compilation}, -- Corresponds to the whole content of a
                                -- compilation with no compilation_unit,
                                -- but possibly containing comments,
                                -- configuration pragmas}, or both.
                                -- A Context is not limited to the number of
                                -- units of A_Configuration_Compilation kind.
                                -- A unit of A_Configuration_Compilation
                                -- does not have a name. This unit
                                -- represents configuration pragmas that
                                -- are "in effect". The only interface that
                                -- returns this unit kind is
                                -- Enclosing_Compilation_Unit when given
                                -- A_Pragma element obtained from Configuration_Pragmas.

   @AdaObjDefn{An_Unknown_Unit});            -- An indeterminable or proprietary unit

@key[subtype] @AdaSubtypeDefn{Name=[A_Subprogram_Declaration],Of=[Unit_Kinds]} @key[is] Unit_Kinds @key[range]
            A_Procedure ..
            A_Function;

@key[subtype] @AdaSubtypeDefn{Name=[A_Subprogram_Renaming],Of=[Unit_Kinds]} @key[is] Unit_Kinds @key[range]
            A_Procedure_Renaming ..
            A_Function_Renaming;

@key[subtype] @AdaSubtypeDefn{Name=[A_Generic_Unit_Declaration],Of=[Unit_Kinds]} @key[is] Unit_Kinds @key[range]
            A_Generic_Procedure ..
            A_Generic_Package;

@key[subtype] @AdaSubtypeDefn{Name=[A_Generic_Unit_Instance],Of=[Unit_Kinds]} @key[is] Unit_Kinds @key[range]
            A_Procedure_Instance ..
            A_Package_Instance;

@key[subtype] @AdaSubtypeDefn{Name=[A_Subprogram_Body],Of=[Unit_Kinds]} @key[is] Unit_Kinds @key[range]
            A_Procedure_Body ..
            A_Function_Body;

@key[subtype] @AdaSubtypeDefn{Name=[A_Library_Unit_Body],Of=[Unit_Kinds]} @key[is] Unit_Kinds @key[range]
            A_Procedure_Body ..
            A_Package_Body;

@key[subtype] @AdaSubtypeDefn{Name=[A_Generic_Renaming],Of=[Unit_Kinds]} @key[is] Unit_Kinds @key[range]
            A_Generic_Procedure_Renaming ..
            A_Generic_Package_Renaming;

@key[subtype] @AdaSubtypeDefn{Name=[A_Renaming],Of=[Unit_Kinds]} @key[is] Unit_Kinds @key[range]
            A_Procedure_Renaming ..
            A_Generic_Package_Renaming;

@key[subtype] @AdaSubtypeDefn{Name=[A_Subunit],Of=[Unit_Kinds]} @key[is] Unit_Kinds @key[range]
            A_Procedure_Body_Subunit ..
            A_Protected_Body_Subunit;
@end{Example}


@LabeledSubClause{type Unit_Classes}

Unit_Classes @Chg{Version=[1],New=[defines],Old=[@en]} classification of public, private, body, and subunit.

@begin{Example}
@key[type] @AdaTypeDefn{Unit_Classes} @key[is] (  -- Reference Manual 10.1.1(12), 10.1.3

   @AdaObjDefn{Not_A_Class},              -- A nil, nonexistent, unknown,
                             -- or configuration compilation unit class.

   @AdaObjDefn{A_Public_Declaration},     -- library_unit_declaration or
                             -- library_unit_renaming_declaration.

   @AdaObjDefn{A_Public_Body},            -- library_unit_body interpreted only as a
                             -- completion. Its declaration is public.

   @AdaObjDefn{A_Public_Declaration_And_Body},
                             -- subprogram_body interpreted as both a
                             -- declaration and body of a library
                             -- subprogram - Reference Manual 10.1.4(4).

   @AdaObjDefn{A_Private_Declaration},    -- private library_unit_declaration or
                             -- private library_unit_renaming_declaration.

   @AdaObjDefn{A_Private_Body},           -- library_unit_body interpreted only as a
                             -- completion. Its declaration is private.

   @AdaObjDefn{A_Separate_Body});         -- separate (parent_unit_name) proper_body.
@end{Example}


@LabeledSubClause{type Unit_Origins}

Unit_Origins @Chg{Version=[1],New=[defines],Old=[@en]} classification of possible unit origination@Chg{Version=[1],New=[.],Old=[]}

@begin{Example}
@key[type] @AdaTypeDefn{Unit_Origins} @key[is] (

   @AdaObjDefn{Not_An_Origin},        -- A nil or nonexistent unit origin
                         -- An_Unknown_Unit can be any origin

   @AdaObjDefn{A_Predefined_Unit},    -- Ada predefined language environment units
                         -- listed in Annex A(2). These include
                         -- Standard and the three root library
                         -- units: Ada, Interfaces, and System,
                         -- and their descendants. i.e., Ada.Text_Io,
                         -- Ada.Calendar, Interfaces.C, etc.

   @AdaObjDefn{An_Implementation_Unit},
                         -- Implementation specific library units,
                         -- e.g., runtime support packages, utility
                         -- libraries, etc. It is not required
                         -- that any implementation supplied units
                         -- have this origin. This is a suggestion.
                         -- Implementations might provide, for
                         -- example, precompiled versions of public
                         -- domain software that could have
                         -- An_Application_Unit origin.

   @AdaObjDefn{An_Application_Unit}); -- Neither A_Predefined_Unit or
                         -- An_Implementation_Unit
@end{Example}

@LabeledSubClause{type Relation_Kinds}

Relation_Kinds @Chg{Version=[1],New=[defines],Old=[@en]} classification of unit
relationships@Chg{Version=[1],New=[.],Old=[]}

@begin{DescribeCode}
@begin{Example}
@key[type] @AdaTypeDefn{Relation_Kinds} @key[is] (
   @AdaObjDefn{Ancestors},
   @AdaObjDefn{Descendants},
@end{Example}

@ChgDeleted{Version=[1],Text=[-----------------------------------------------------------------------------
Definition:  ANCESTORS of a unit; DESCENDANTS of a unit]}

@i{Ancestors}@Defn2{Term=[Ancestor],Sec=[of a library unit]} of a library unit
are itself, its parent, its parent's
parent, and so on. (Standard is an ancestor of every library unit).

The @i{Descendants} relation is the inverse of the ancestor relation.
Reference Manual 10.1.1(11).@Defn2{Term=[Ancestor],Sec=[of a library unit]}

@ChgDeleted{Version=[1],Text=[-----------------------------------------------------------------------------]}

@begin{Example}
   @AdaObjDefn{Supporters},
@end{Example}

@ChgDeleted{Version=[1],Text=[-----------------------------------------------------------------------------
Definition:  SUPPORTERS of a unit]}

@i{Supporters} of a compilation unit are units on which it semantically
depends. Reference Manual 10.1.1(26).@Defn2{Term=[Supporter],Sec=[of a compilation unit]}

The Supporters relation is transitive; units that are supporters of library
units mentioned in a with clause of a compilation unit are also supporters
of that compilation unit.

A parent declaration is a Supporter of its descendant units.

Each library unit mentioned in the with clauses of a compilation unit
is a Supporter of that compilation unit and (recursively) any
completion, child units, or subunits that are included in the declarative
region of that compilation unit. Reference Manual 8.1(7-10).

A library_unit_body has as a Supporter, its corresponding
library_unit_declaration, if any.

The parent body of a subunit is a Supporter of the subunit.

@ChgDeleted{Version=[1],Text=[-----------------------------------------------------------------------------]}

@begin{Example}
   @AdaObjDefn{Dependents},
@end{Example}

@ChgDeleted{Version=[1],Text=[-----------------------------------------------------------------------------
Definition:  DEPENDENTS of a unit]}

@i{Dependents} of a compilation unit are all the compilation units that
depend semantically on it.@Defn2{Term=[Dependents],Sec=[of a compilation unit]}

The Dependents relation is transitive; Dependents of a unit include the
unit's Dependents, each dependent unit's Dependents, and so on. A unit
that is a dependent of a compilation unit also is a dependent
of the compilation unit's Supporters.

Child units are Dependents of their ancestor units.

A compilation unit that mentions other library units in its with
clauses is one of the Dependents of those library units.

A library_unit_body is a Dependent of its corresponding
library_unit_declaration, if any.

A subunit is a Dependent of its parent body.

A compilation unit that contains an attribute_reference of a type defined
in another compilation unit is a Dependent of the other unit.

For example:

@begin{Display}
If A withs B and B withs C
then A directly depends on A, B directly depends on C,
    A indirectly depends on C, and
    both A and B are dependents of C.
@end{Display}

Dependencies between compilation units may also be introduced by
inline inclusions (Reference Manual 10.1.4(7)) and for certain other compiler
optimizations. These relations are intended to reflect all of these
considerations.

@ChgDeleted{Version=[1],Text=[-----------------------------------------------------------------------------]}

@begin{Example}
   @AdaObjDefn{Family},
@end{Example}

@ChgDeleted{Version=[1],Text=[-----------------------------------------------------------------------------
Definition:  FAMILY of a unit]}

The @i{family} of a given unit is defined as the set of compilation
units that comprise the given unit's declaration, body, descendants,
and subunits (and subunits of subunits and descendants,
etc.).@Defn2{Term=[Family],Sec=[of a compilation unit]}

@ChgDeleted{Version=[1],Text=[-----------------------------------------------------------------------------]}

@begin{Example}
   @AdaObjDefn{Needed_Units});
@end{Example}

@ChgDeleted{Version=[1],Text=[-----------------------------------------------------------------------------
Definition:  NEEDED UNITS of a unit; CLOSURE of a unit]}

The @i{needed units} of a given unit is defined as the set of all
the Ada units ultimately needed by that unit to form a partition.
Reference Manual 10.2(2-7).@Defn2{Term=[Needed units],Sec=[of a compilation unit]}

The term @i{closure} is commonly used with similar
meaning.@Defn2{Term=[Closure],Sec=[of a compilation unit]}

For example:

Assume the body of C has a subunit C.S and the declaration of C has child units C.Y and C.Z.

@begin{Display}
If A withs B, B withs C, B withs C.Y, and C does not with a library
unit. Then the needed units of A are:
    library unit declaration C
    child library unit declaration C.Y
    child library unit body C.Y, if any
    library unit body C
    subunit C.S
    library unit declaration B
    library unit body B, if any
    library unit declaration A
    library unit body A, if any

Child unit C.Z is only part of the Needed_Units if it is needed.
@end{Display}
@end{DescribeCode}

@LabeledClause{type Traverse_Control}

Traverse_Control @Chg{Version=[1],New=[defines],Old=[@en]} controls for the
traversal generic provided in package
Asis.Iterator. It is defined in package Asis to facilitate automatic translation
to IDL (See @RefSecNum{Miscellaneous ASIS I/O and IDL approaches} for details).

@begin{Example}
@Key[type] @AdaTypeDefn{Traverse_Control} @key[is] (

   @AdaObjDefn{Continue},               -- Continues the normal depth-first traversal.

   @AdaObjDefn{Abandon_Children},       -- Prevents traversal of the current element's
                           -- children.

   @AdaObjDefn{Abandon_Siblings},       -- Prevents traversal of the current element's
                           -- children and remaining siblings.

   @AdaObjDefn{Terminate_Immediately}); -- Does exactly that.
@end{Example}


@LabeledClause{type Program_Text}

@begin{Example}
@key[subtype] @AdaSubtypeDefn{Name=[Program_Text],Of=[Wide_String]} @key[is] Wide_String;
@end{Example}

@Comment{The private part doesn't belong in the standard!!}
@begin{Example}
@ChgDeleted{Version=[1],Text=[@key[private]]}

@ChgDeleted{Version=[1],Text=[    @key[type] Context @key[is] (Implementation_Defined);
    Nil_Context : @key[constant] Context := Implementation_Defined;]}

@ChgDeleted{Version=[1],Text=[    @key[type] Element @key[is] (Implementation_Defined);
    Nil_Element : @key[constant] Element := Implementation_Defined;
    Nil_Element_List : @key[constant] Element_List (1 .. 0) :=
        (1 .. 0 => Nil_Element);]}

@ChgDeleted{Version=[1],Text=[    @key[type] Compilation_Unit @key[is] (Implementation_Defined);
    Nil_Compilation_Unit : @key[constant] Compilation_Unit :=
        Implementation_Defined;
    Nil_Compilation_Unit_List : @key[constant] Compilation_Unit_List (1 .. 0) :=
        (1 .. 0 => Nil_Compilation_Unit);]}

@ChgDeleted{Version=[1],Text=[@key[end] Asis;]}
@end{Example}

