@Part(08, Root="ada.mss")

@Comment{$Date: 2000/05/29 05:47:20 $}
@LabeledSection{Visibility Rules}

@Comment{$Source: e:\\cvsroot/ARM/Source/08.mss,v $}
@Comment{$Revision: 1.15 $}

@begin{Intro}
@redundant[The rules defining the scope of declarations and the rules defining
which @nt{identifier}s, @nt{character_literal}s, and
@nt{operator_symbol}s are visible at (or from) various places in the text of
the program are described in this section.  The formulation of these
rules uses the notion of a declarative region.

As explained in Section 3,
a declaration declares a view of an entity
and associates a defining name with that view.
The view comprises an identification of the viewed entity,
and possibly additional properties.
A usage name denotes a declaration.
It also denotes the view declared by that declaration,
and denotes the entity of that view.
Thus, two different usage names might denote two different views of
the same entity; in this case they denote the same entity.]
@begin{Honest}
In some cases, a usage name that denotes a declaration
does not denote the view declared by that declaration,
nor the entity of that view,
but instead denotes a view of the current instance of the entity,
and denotes the current instance of the entity.
This sometimes happens when the usage name occurs inside
the declarative region of the declaration.
@end{Honest}
@end{Intro}

@begin{DiffWord83}
We no longer define the term ``basic operation;''
thus we no longer have to worry about the visibility of them.
Since they were essentially always visible in Ada 83, this change has
no effect.  The reason for this change is that the definition in Ada
83 was confusing, and not quite correct,
and we found it difficult to fix.  For example, one
wonders why an @nt{if_statement} was not a basic operation of type
Boolean.  For another example, one wonders what it meant for a basic
operation to be ``inherent in'' something.
Finally, this fixes the problem addressed by AI-00027/07.
@end{DiffWord83}

@LabeledClause{Declarative Region}

@begin{StaticSem}
@Defn2{Term=[declarative region], Sec=(of a construct)}
For each of the following constructs,
there is a portion of the program text
called its @i{declarative region},
@Redundant[within which nested declarations can occur]:
@begin(itemize)
  any declaration, other than that of an enumeration type,
  that is not a completion @Redundant[of a previous declaration];

  a @nt{block_statement};

  a @nt{loop_statement};

  an @nt{accept_statement};

  an @nt{exception_handler}.
@end(itemize)

The declarative region includes the text of the construct
together with additional text determined @Redundant[(recursively)],
as follows:
@begin{Itemize}
If a declaration is included, so is its completion, if any.

If the declaration of a library unit
@Redundant[(including Standard @em
see @RefSecNum{Compilation Units - Library Units})] is included,
so are the declarations of any child units
@Redundant[(and their completions, by the previous rule)].
The child declarations occur after the declaration.

If a @nt{body_stub} is included,
so is the corresponding @nt{subunit}.

If a @nt{type_declaration} is included,
then so is a corresponding @nt{record_representation_clause},
if any.
@begin{Reason}
This is so that the @nt{component_declaration}s can be directly
visible in the @nt{record_representation_clause}.
@end{Reason}
@end{Itemize}

The declarative region of a declaration is also called the
@i{declarative region} of any view or entity declared by the
declaration.
@begin{Reason}
The constructs that have declarative regions
are the constructs that can have declarations nested inside them.
Nested declarations are declared in that declarative region.
The one exception is for enumeration literals;
although they are nested inside an enumeration type declaration,
they behave as if they were declared at the same level as the type.
@end{Reason}
@begin{Honest}
A declarative region does not include @nt{parent_unit_name}s.
@end{Honest}
@begin{Ramification}
A declarative region does not include @nt{context_clause}s.
@end{Ramification}

@Defn{occur immediately within}
@Defn{immediately within}
@Defn2{Term=[within],Sec=(immediately)}
@Defn{immediately enclosing}
@Defn2{Term=[enclosing],Sec=(immediately)}
A declaration occurs @i{immediately within} a declarative region if this
region is the innermost declarative region that
encloses the declaration
(the @i{immediately enclosing} declarative region),
not counting the declarative region (if any)
associated with the declaration itself.
@begin{Discussion}
Don't confuse the declarative region of a declaration
with the declarative region in which it immediately occurs.
@end{Discussion}

@redundant[@Defn{local to}
A declaration is @i{local} to a declarative region if
the declaration occurs immediately within the declarative region.]
@begin{Ramification}
That is,
"occurs immediately within" and "local to" are synonyms
(when referring to declarations).
@end{Ramification}
@redundant[An entity is @i{local} to a declarative region if the entity is
declared by a declaration that is local to the declarative region.]
@begin{Ramification}
Thus, ``local to'' applies to both declarations and entities,
whereas ``occurs immediately within'' only applies to declarations.
We use this term only informally;
for cases where precision is required,
we use the term "occurs immediately within",
since it is less likely to cause confusion.
@end{Ramification}

@Defn{global to}
A declaration is @i{global} to a declarative region
if the declaration occurs immediately within
another declarative region that encloses the
declarative region.
An entity is @i{global} to a declarative region if the entity is
declared by a declaration that is global to the declarative region.
@end{StaticSem}

@begin{Notes}
The children of a parent library unit are inside the parent's
declarative region, even though they do not occur inside the
parent's declaration or body.
This implies that one can use (for example) "P.Q" to refer to
a child of P whose defining name is Q,
and that after "@key[use] P;" Q can refer (directly) to that child.

As explained above
and in @RefSec{Compilation Units - Library Units},
all library units are descendants of Standard,
and so are contained in the declarative region of Standard.
They are @i{not} inside the
declaration or body of Standard,
but they @i{are} inside its declarative region.

For a declarative region that comes in multiple parts,
the text of the declarative region does not contain any text that might appear
between the parts.
Thus, when a portion of a declarative region is said to extend from one
place to another in the declarative region,
the portion does not contain any text that
might appear between the parts of the declarative region.
@begin{Discussion}
It is necessary for the things that have a declarative region to
include
anything that contains declarations (except for enumeration type
declarations).
This includes any declaration that has a profile
(that is, @nt{subprogram_declaration},
@nt{subprogram_body},
@nt{entry_declaration},
@nt{subprogram_renaming_declaration},
@nt{formal_subprogram_declaration},
access-to-subprogram @nt{type_declaration}),
anything that has a @nt{discriminant_part}
(that is, various kinds of @nt{type_declaration}),
anything that has a @nt{component_list}
(that is, record @nt{type_declaration} and
record extension @nt{type_declaration}),
and finally the declarations of task and protected units and packages.
@end{Discussion}
@end{Notes}

@begin{DiffWord83}
It was necessary to extend Ada 83's definition of declarative region
to take the following Ada 9X features into account:
@begin{Itemize}
Child library units.

Derived types/type extensions @em we need a declarative region for
inherited components and also for new components.

All the kinds of types that allow discriminants.

Protected units.

Entries that have bodies instead of accept statements.

The @nt{choice_parameter_specification} of an @nt{exception_handler}.

The formal parameters of access-to-subprogram types.

Renamings-as-body.
@end{Itemize}

Discriminated and access-to-subprogram type declarations
need a declarative region.
Enumeration type declarations cannot have one,
because you don't have to say "Color.Red" to refer to the literal Red
of Color.
For other type declarations,
it doesn't really matter whether or not there is an
associated declarative region,
so for simplicity, we give one to all types except enumeration types.

We now say that an @nt{accept_statement} has its own declarative
region, rather than being part of the declarative region of the
@nt{entry_declaration},
so that declarative regions are properly nested regions of text,
so that it makes sense to talk about "inner declarative regions,"
and "...extends to the end of a declarative region."
Inside an @nt{accept_statement}, the @nt{name} of one of the parameters
denotes the @nt{parameter_specification} of the @nt{accept_statement},
not that of the @nt{entry_declaration}.  If the @nt{accept_statement} is
nested within a @nt{block_statement}, these
@nt{parameter_specification}s can hide declarations of the
@nt{block_statement}.
The semantics of such cases was unclear in RM83.
@begin{Honest}
  Unfortunately, we have the same problem for the entry name
  itself @em it should denote the @nt{accept_statement},
  but @nt{accept_statement}s are not declarations.
  They should be, and they should hide the entry from all visibility
  within themselves.
@end{Honest}

Note that we can't generalize this to @nt{entry_bodies},
or other bodies, because the @nt{declarative_part} of a
body is not supposed to contain (explicit) homographs of
things in the declaration.
It works for @nt{accept_statement}s only because an
@nt{accept_statement} does not have a @nt{declarative_part}.

To avoid confusion,
we use the term ``local to'' only informally in Ada 9X.
Even RM83 used the term incorrectly (see, for example, RM83-12.3(13)).

In Ada 83, (root) library units were inside Standard;
it was not clear whether the declaration or body of Standard
was meant.
In Ada 9X, they are children of Standard,
and so occur immediately within Standard's declarative
region, but not within either the declaration or the body.
(See RM83-8.6(2) and RM83-10.1.1(5).)
@end{DiffWord83}

@LabeledClause{Scope of Declarations}

@begin{Intro}
@redundant[For each declaration, the language rules define a certain
portion of the program text called the @i{scope} of the declaration.
The scope of a declaration is also called the scope of any view
or entity declared by the declaration.
Within the scope of an entity, and only there,
there are places where it is legal to refer
to the declared entity.
These places are defined by the rules of visibility and overloading.]
@end{Intro}

@begin{StaticSem}
@Defn2{Term=[immediate scope], Sec=(of a declaration)}
The @i{immediate scope} of a declaration
is a portion of the declarative region immediately enclosing
the declaration.
The immediate scope starts at the beginning of the declaration,
except in the case of an overloadable declaration,
in which case the immediate scope starts just after the place
where the profile of the callable entity is determined
(which is at the end of the @nt<_specification> for the callable entity,
or at the end of the @nt<generic_instantiation> if an instance).
@begin{Reason}
The reason for making overloadable declarations with profiles
special is to simplify compilation:
until the compiler has determined the profile,
it doesn't know which other declarations are homographs of this one,
so it doesn't know which ones this one should hide.
Without this rule, two passes over the @nt<_specification> or
@nt<generic_instantiation> would be required to
resolve names that denote things with the same name as this one.
@end{Reason}
The immediate scope extends to the end of the declarative region,
with the following exceptions:
@begin{Itemize}
The immediate scope of a @nt{library_item} includes only its semantic
dependents.
@begin{Reason}
Section 10 defines only a partial ordering of @nt{library_item}s.
Therefore, it is a good idea to restrict the immediate scope
(and the scope, defined below)
to semantic dependents.

Consider also examples like this:
@begin{Example}
@key[package] P @key[is] @key[end] P;

@key[package] P.Q @key[is]
    I : Integer := 0;
@key[end] P.Q;

@key[with] P;
@key[package] R @key[is]
    @key[package] X @key[renames] P;
    X.Q.I := 17; --@RI{ Illegal!}
@key[end] R;
@end{Example}

The scope of P.Q does not contain R.
Hence, neither P.Q nor X.Q are visible within R.
However, the name R.X.Q would be visible in some other
library unit where both R and P.Q are visible
(assuming R were made legal by removing the offending declaration).
@end{Reason}

The immediate scope of
a declaration in the private part of a library unit does
not include the visible part of any
public descendant of that library unit.
@Pdefn2{Term=[descendant],Sec=(relationship with scope)}
@begin{Ramification}
In other words, a declaration in the private part can be
visible within the visible part, private part and body of a private
child unit.
On the other hand, such a declaration
can be visible within only the private part and body of a public
child unit.
@end{Ramification}
@begin{Reason}
The purpose of this rule is to prevent children from giving
private information to clients.
@end{Reason}
@begin{Ramification}
For a public child subprogram,
this means that the parent's private part is not visible in the
@nt{formal_part}s of the declaration and of the body.
This is true even for @nt{subprogram_bodies} that are not
completions.
For a public child generic unit,
it means that the parent's private part is not visible in the
@nt{generic_formal_part}, as well as in
the first list of @nt{basic_declarative_item}s (for a generic package),
or the @nt{formal_part}(s) (for a generic subprogram).
@end{Ramification}
@end{Itemize}

@Defn{visible part}
@Redundant[The @i(visible part) of (a view of) an entity
is a portion of the text of its declaration
containing declarations that are visible from outside.]
@RootDefn{private part}
The @i{private part} of (a view of) an entity that has a visible part
contains all declarations within the declaration of
(the view of) the entity,
except those in the visible part;
@Redundant[these are not visible from outside.
Visible and private parts are defined only for these kinds of
entities: callable entities, other program units,
and composite types.]
@begin{Itemize}
@PDefn2{Term=[visible part], Sec=(of a view of a callable entity)}
The visible part of a view of a callable entity is its profile.

@PDefn2{Term=[visible part], Sec=(of a view of a composite type)}
The visible part of a composite type other than a task or protected type
consists of the declarations of
all components declared @Redundant[(explicitly or implicitly)]
within the @nt{type_declaration}.

@PDefn2{Term=[visible part], Sec=(of a generic unit)}
The visible part of a generic unit
includes the @nt{generic_formal_part}.
For a generic package, it also includes
the first list of @nt{basic_declarative_item}s of the
@nt{package_specification}.
For a generic subprogram, it also includes
the profile.
@begin{Reason}
Although there is no way to reference anything but the formals from
outside a generic unit, they are still in the visible part in the sense that
the corresponding declarations in an instance can be referenced
(at least in some cases).
In other words, these declarations have an effect on the outside world.
The visible part of a generic unit needs to be defined
this way in order to properly support
the rule that makes a parent's private part invisible within a
public child's visible part.
@end{Reason}
@begin{Ramification}
The visible part of an instance of a generic unit is as defined
for packages and subprograms;
it is not defined in terms of the visible part of a generic unit.
@end{Ramification}

@Redundant[The visible part of a package, task unit, or protected
unit consists of declarations in the program unit's declaration
other than those following the reserved word @key{private}, if any;
see @RefSecNum{Package Specifications and Declarations}
and @RefSecNum{Formal Packages} for packages,
@RefSecNum{Task Units and Task Objects} for task units,
and @RefSecNum{Protected Units and Protected Objects}
for protected units.]
@end{Itemize}

@Defn2{Term=[scope], Sec=(of a declaration)}
The scope of a declaration always
contains the immediate scope of the declaration.
In addition, for a given declaration that occurs immediately within
the visible part of an outer declaration,
or is a public child of an outer declaration,
the scope of the given declaration
extends to the end of the scope of the outer declaration,
except that the scope of a @nt{library_item} includes only its
semantic dependents.
@begin{Ramification}
Note the recursion.
If a declaration appears in the visible part of a library unit,
its scope extends to the end of the scope of the library unit,
but since that only includes dependents of the declaration of the library unit,
the scope of the inner declaration also only includes those dependents.
If X renames library package P,
which has a child Q, a @nt{with_clause} mentioning P.Q is necessary to
be able to refer to X.Q,
even if P.Q is visible at the place where X is declared.
@end{Ramification}

@Defn2{Term=[immediate scope], Sec=[of (a view of) an entity]}
The immediate scope of a declaration is also the immediate scope
of the entity or view declared by the declaration.
@Defn2{Term=[scope], Sec=[of (a view of) an entity]}
Similarly,
the scope of a declaration is also the scope
of the entity or view declared by the declaration.
@begin{Ramification}
The rule for immediate scope implies the following:
@begin{Itemize}
If the declaration is that of a library unit,
then the immediate scope includes the declarative region of the
declaration itself, but not other places,
unless they are within the scope of a @nt{with_clause} that mentions the
library unit.

@NoPrefix@;It is necessary to attach the semantics of @nt{with_clause}s to
[immediate] scopes (as opposed to visibility),
in order for various rules to work properly.
A library unit should hide a homographic implicit declaration that
appears in its parent, but only within the scope of a @nt{with_clause}
that mentions the library unit.
Otherwise, we would violate the "legality determinable via semantic
dependences" rule of @RefSec{Program Structure and Compilation Issues}.
The declaration of a library unit should be allowed to be a homograph of
an explicit declaration in its parent's body,
so long as that body does not mention the library unit in a
@nt{with_clause}.

@NoPrefix@;This means that one cannot denote the declaration of the library unit,
but one might still be able to denote the library unit via another
view.

@NoPrefix@;A @nt{with_clause} does not make the declaration of a library unit
visible; the lack of a @nt{with_clause} prevents it from being visible.
Even if a library unit is mentioned in a @nt{with_clause},
its declaration can still be hidden.

The completion of the declaration of a library unit
(assuming that's also a declaration)
is not visible, neither directly nor by selection,
outside that completion.

The immediate scope of
a declaration immediately within the body of a library unit
does not include any child of that library unit.

@NoPrefix@;This is needed to prevent children from looking inside their
parent's body.  The children are in the declarative region of the
parent, and they might be after the parent's body.
Therefore, the scope of a declaration that occurs immediately within
the body might include some children.
@end{Itemize}
@end{Ramification}
@end{StaticSem}

@begin{Notes}
There are notations for denoting visible declarations
that are not directly visible.
For example, @nt{parameter_specification}s are in the visible part of a
@nt{subprogram_declaration} so that they can be used in
named-notation calls appearing outside the called subprogram.
For another example,
declarations of the visible part of a package can be denoted by expanded names
appearing outside the package,
and can be made directly visible by a @nt{use_clause}.
@begin{Ramification}
There are some obscure involving generics cases in which there is
no such notation.
See Section 12.
@end{Ramification}
@end{Notes}

@begin{Extend83}
The fact that the immediate scope of an overloadable declaration does
not include its profile is new to Ada 9X.  It replaces
RM83-8.3(16), which said that within
a subprogram specification and within the formal part of an
entry declaration or accept statement, all declarations with
the same designator as the subprogram or entry were hidden from all
visibility.
The RM83-8.3(16) rule seemed to be overkill, and created both
implementation difficulties and unnecessary semantic complexity.
@end{Extend83}

@begin{DiffWord83}
We no longer need to talk about the scope of notations,
@nt{identifier}s, @nt{character_literal}s, and @nt{operator_symbol}s.

The notion of "visible part" has been extended in Ada 9X.
The syntax of
task and protected units now allows private parts,
thus requiring us to be able to talk about the visible part as well.
It was necessary to extend the concept to subprograms
and to generic units, in order for the visibility rules
related to child library units to work properly.
It was necessary to define the concept separately for
generic formal packages, since their visible part is
slightly different from that of a normal package.
Extending the concept to composite types made the
definition of scope slightly simpler.
We define visible part for some things elsewhere,
since it makes a big difference to the user for those things.
For composite types and subprograms, however,
the concept is used only in arcane visibility rules,
so we localize it to this clause.

In Ada 83, the semantics of @nt{with_clause}s was described
in terms of visibility.
It is now described in terms of [immediate] scope.

We have clarified that the following is illegal
(where Q and R are library units):
@begin{Example}
@key[package] Q @key[is]
    I : Integer := 0;
@key[end] Q;

@key[package] R @key[is]
    @key[package] X @key[renames] Standard;
    X.Q.I := 17; --@RI{ Illegal!}
@key[end] R;
@end{Example}

even though Q is declared in the declarative region of Standard,
because R does not mention Q in a @nt{with_clause}.
@end{DiffWord83}

@LabeledClause{Visibility}

@begin{Intro}
@redundant[@Defn{visibility rules}
The @i{visibility rules},
given below, determine which declarations are
visible and directly visible at each place within a program.
The visibility rules apply to both explicit and implicit declarations.]
@end{Intro}

@begin{StaticSem}
@Defn2{Term=[visibility], Sec=(direct)}
@Defn{directly visible}
@Defn{directly visible}
A declaration is defined to be @i{directly visible} at places
where a @nt<name> consisting of only an @nt{identifier} or
@nt{operator_symbol} is sufficient to denote the declaration;
that is, no @nt<selected_component> notation or special context
(such as preceding => in a named association) is necessary
to denote the declaration.
@Defn{visible}
A declaration is defined to be @i{visible} wherever it is
directly visible, as well as at other places where
some @nt<name> (such as a @nt<selected_component>) can denote
the declaration.

The syntactic category @nt<direct_name> is used to indicate
contexts where direct visibility is required.
The syntactic category @nt<selector_name> is used to indicate
contexts where visibility, but not direct visibility,
is required.

@Defn2{Term=[visibility], Sec=(immediate)}
@Defn2{Term=[visibility], Sec=(use clause)}
There are two kinds of direct visibility:
@i{immediate visibility} and @i{use-visibility}.
@Defn{immediately visible}
A declaration is immediately visible at a place if it is directly
visible because the place is within its immediate scope.
@Defn{use-visible}
A declaration is use-visible if it is directly visible
because of a @nt{use_clause} (see @RefSecNum{Use Clauses}).
Both conditions can apply.

@Defn{hiding}
A declaration can be @i{hidden}, either from direct visibility,
or from all visibility,
within certain parts of its scope.
@Defn{hidden from all visibility}
Where @i{hidden from all visibility},
it is not visible at all (neither using a @nt<direct_name>
nor a @nt<selector_name>).
@Defn{hidden from direct visibility}
Where @i{hidden from direct visibility}, only direct visibility is lost;
visibility using a @nt<selector_name> is still possible.

@redundant[@Defn{overloaded}
Two or more declarations are @i{overloaded} if
they all have the same defining name
and there is a place where they are all directly visible.]
@begin{Ramification}
Note that a @nt{name} can have more than one possible interpretation
even if it denotes a non-overloadable entity.
For example, if there are two functions F that return records,
both containing a component called C, then
the name F.C has two possible interpretations,
even though component declarations are not overloadable.
@end{Ramification}

@Defn{overloadable}
The declarations of callable entities
@Redundant[(including enumeration literals)]
are @i{overloadable}@Redundant[,
meaning that overloading is allowed for them].
@begin{Ramification}
A @nt{generic_declaration} is not overloadable within its own
@nt{generic_formal_part}.
This follows from the rules about when a @nt{name} denotes a current
instance.
See AI-00286.  This implies that within a
@nt{generic_formal_part}, outer declarations with the same defining name
are hidden from direct visibility.  It also implies that if a generic
formal parameter has the same defining name as the generic itself,
the formal parameter hides the generic from direct visibility.
@end{Ramification}

@Defn{homograph}
Two declarations are @i{homographs}
if they have the same defining name,
and, if both are overloadable,
their profiles are type conformant.
@PDefn{type conformance}
@redundant[An inner declaration hides any outer homograph from direct visibility.]

@Redundant[Two homographs are not generally allowed
immediately within the same declarative region unless one
@i{overrides} the other (see Legality Rules below).]
@Defn{override}
A declaration overrides another homograph that occurs
immediately within the same declarative region in the
following cases:
@begin{Itemize}
An explicit declaration overrides an implicit declaration of a primitive
subprogram, @Redundant[regardless of which declaration occurs first];
@begin{Ramification}
And regardless of whether the explicit
declaration is overloadable or not.

The ``regardless of which declaration occurs first''
is there because the explicit declaration could be a primitive subprogram
of a partial view, and then the full view might inherit a homograph.
We are saying that the explicit one wins
(within its scope), even though the implicit one
comes later.

If the overriding declaration is also a subprogram,
then it is a primitive subprogram.

As explained in @RefSec{Private Operations},
some inherited primitive subprograms are never declared.
Such subprograms cannot be overridden,
although they can be reached by dispatching calls
in the case of a tagged type.
@end{Ramification}

The implicit declaration of an inherited operator overrides
that of a predefined operator;
@begin{Ramification}
In a previous version of Ada 9X, we tried to avoid the notion of
predefined operators, and say that they were inherited from some
magical root type.
However, this seemed like too much mechanism.
Therefore, a type can have a predefined "+" as well as an inherited "+".
The above rule says the inherited one wins.

The ``regardless of which declaration occurs first'' applies here
as well, in the case where @nt{derived_type_declaration} in the visible
part of a public library unit derives from a private type declared in
the parent unit, and the full view of the parent type has additional
predefined operators, as explained in @RefSec{Private Operations}.
Those predefined operators can be overridden by inherited subprograms
implicitly declared earlier.
@end{Ramification}

An implicit declaration of an inherited subprogram
overrides a previous implicit declaration of an inherited
subprogram.

@Redundant[For an implicit declaration of a primitive subprogram in a
generic unit, there is a copy of this declaration in an instance.]
However,
a whole new set of primitive
subprograms is implicitly
declared for
each type declared within the visible part of the instance.
These new declarations occur immediately after the type
declaration, and override the copied ones.
@Redundant[The copied ones can be called only from within the instance;
the new ones can be called only from outside the instance,
although for tagged types, the body of a new one can be executed
by a call to an old one.]
@begin{Discussion}
In addition, this is also stated redundantly (again),
and is repeated, in @RefSec{Generic Instantiation}.
The rationale for the rule is explained there.
@end{Discussion}
@end{Itemize}

@Defn{visible}
@RootDefn{hidden from all visibility}
A declaration is visible within its scope,
except where hidden from all visibility,
as follows:
@begin{Itemize}
@PDefn2{Term=[hidden from all visibility], Sec=(for overridden declaration)}
An overridden declaration is hidden from all visibility within the
scope of the overriding declaration.
@begin{Ramification}
We have to talk about the scope of the overriding declaration,
not its visibility, because it hides
even when it is itself hidden.

Note that the scope of an explicit @nt{subprogram_declaration}
does not start until after its profile.
@end{Ramification}

@PDefn2{Term=[hidden from all visibility], Sec=(within the declaration itself)}
A declaration is hidden from all visibility until the end of the
declaration, except:
@begin(itemize)
  For a record type or record extension,
  the declaration is hidden from all visibility only
  until the reserved word @b(record);

  For a @nt{package_declaration}, task declaration,
  protected declaration, @nt{generic_package_declaration},
  or @nt{subprogram_body},
  the declaration is
  hidden from all visibility only until the reserved word @b(is)
  of the declaration.
@begin{Ramification}
We're talking about the @key{is} of the construct itself, here,
not some random @key{is} that might appear in a
@nt{generic_formal_part}.
@end{Ramification}
@end(itemize)

@PDefn2{Term=[hidden from all visibility], Sec=(for a declaration completed
  by a subsequent declaration)}
If the completion of a declaration is a declaration,
then within the scope of the completion,
the first declaration is hidden from all visibility.
Similarly, a @nt{discriminant_specification} or
@nt{parameter_specification} is hidden within the scope of a
corresponding @nt{discriminant_specification} or
@nt{parameter_specification} of a corresponding completion,
or of a corresponding @nt{accept_statement}.
@begin{Ramification}
This rule means, for example, that within the scope of a
@nt{full_type_declaration} that completes a
@nt{private_type_declaration},
the name of the type will denote the @nt{full_type_declaration},
and therefore the full view of the type.
On the other hand, if the completion is not a declaration,
then it doesn't hide anything,
and you can't denote it.
@end{Ramification}

@PDefn2{Term=[hidden from all visibility], Sec=(by lack of a
@nt{with_clause})}
The declaration of a library unit
(including a @nt{library_unit_renaming_declaration})
is hidden from all visibility
except at places that are within its declarative region
or within the scope of a @nt{with_clause} that mentions it.

@Redundant[For each declaration or renaming of a generic unit as a child of
some parent generic package, there is a corresponding declaration nested
immediately within each instance of the parent.]
Such a nested declaration is hidden from all visibility
except at places that are
within the scope of a @nt{with_clause} that mentions the child.

@begin{Discussion}
This is the rule that prevents @nt{with_clause}s from being
transitive;
the [immediate] scope includes indirect semantic dependents.
@end{Discussion}
@end{Itemize}

@Defn{directly visible}
@Defn{immediately visible}
@Defn2{Term=[visibility], Sec=(direct)}
@Defn2{Term=[visibility], Sec=(immediate)}
A declaration with a @nt{defining_identifier} or
@nt{defining_operator_symbol} is immediately visible
@Redundant[(and hence
directly visible)] within its immediate scope
@RootDefn{hidden from direct visibility}
except where hidden
from direct visibility, as follows:
@begin{Itemize}
  @PDefn2{Term=[hidden from direct visibility], Sec=(by an inner homograph)}
  A declaration is hidden from direct visibility
  within the immediate scope of a homograph of the
  declaration, if the homograph occurs within an inner declarative
  region;

  @PDefn2{Term=[hidden from direct visibility],
    Sec=(where hidden from all visibility)}
  A declaration is also hidden from direct visibility
  where hidden from all visibility.
@end{Itemize}
@end{StaticSem}

@begin{Resolution}
@PDefn2{Term=[possible interpretation], Sec=(for @nt{direct_name}s)}
A @nt{direct_name} shall resolve to denote a directly visible
declaration whose defining name is the same as the @nt{direct_name}.
@PDefn2{Term=[possible interpretation], Sec=(for @nt{selector_name}s)}
A @nt{selector_name} shall resolve to denote
a visible declaration whose defining name is the same as the
@nt{selector_name}.
@begin{Discussion}
"The same as" has the obvious meaning here,
so for +,
the possible interpretations are declarations whose defining name is "+"
(an @nt{operator_symbol}).
@end{Discussion}

These rules on visibility and direct visibility do not apply
in a @nt{context_clause}, a @nt{parent_unit_name},
or a @nt{pragma} that appears at the place of a
@nt{compilation_unit}.
For those contexts, see the rules
in @RefSec{Environment-Level Visibility Rules}.
@begin{Ramification}
Direct visibility is irrelevant for @nt{character_literal}s.
In terms of overload resolution
@nt{character_literal}s are similar to other literals,
like @key{null} @em see @RefSecNum{Literals}.
For @nt{character_literal}s, there is no need to worry about
hiding, since there is no way to declare homographs.
@end{Ramification}
@end{Resolution}

@begin{Legality}
An explicit declaration is illegal if there is a
homograph occurring immediately within the same
declarative region that is visible at the place of the
declaration, and is not hidden from all visibility by the explicit
declaration.
Similarly, the @nt<context_clause> for a
@nt<subunit> is illegal if it mentions (in a
@nt<with_clause>) some library unit, and there is a homograph
of the library unit that is visible at the place of the corresponding
stub, and the homograph and the mentioned library unit are both
declared immediately within the same declarative region.
@PDefn{generic contract issue}
These rules also apply to dispatching operations declared
in the visible part of an instance of a generic unit.
However, they do not apply to other overloadable declarations in
an instance@Redundant[; such declarations may have type conformant profiles
in the instance, so long as the corresponding declarations in the generic
were not type conformant].
@PDefn{type conformance}
@begin{Discussion}
Normally, these rules just mean you can't explicitly
declare two homographs
immediately within the same declarative region.
The wording is designed to handle the
following special cases:
@begin{Itemize}
If the second declaration completes the first one,
the second declaration is legal.

If the body of a library unit contains an explicit homograph of a child
of that same library unit, this is illegal only if the body
mentions the child in its @nt<context_clause>, or if
some subunit mentions the child.
Here's an example:
@begin{Example}
@key[package] P @key[is]
@key[end] P;

@key[package] P.Q @key[is]
@key[end] P.Q;

@key[package] @key[body] P @key[is]
    Q : Integer; --@RI{ OK; we cannot see package P.Q here.}
    @key[procedure] Sub @key[is] @key[separate];
@key[end] P;

@key[with] P.Q;
@key[separate](P)
@key[procedure] Sub @key[is] --@RI{ Illegal.}
@key[begin]
    @key[null];
@key[end] Sub;
@end{Example}

@NoPrefix@;If package body P said "@key[with] P.Q;", then it would be illegal
to declare the homograph Q: Integer.  But it does not, so the
body of P is OK.
However, the subunit would be able to see both P.Q's,
and is therefore illegal.

@NoPrefix@;A previous version of Ada 9X allowed the subunit,
and said that references to P.Q would tend to be ambiguous.
However, that was a bad idea, because it requires overload resolution
to resolve references to directly visible non-overloadable
homographs, which is something compilers have never before been
required to do.
@end{Itemize}

Note that we need to be careful which things we make "hidden from all
visibility" versus which things we make simply illegal for names to
denote.  The distinction is subtle.
The rules that disallow names denoting components within a type
declaration (see @RefSecNum{Discriminants}) do not make the components
invisible at those places, so that the above rule makes components with
the same name illegal.
The same is true for the rule that disallows names denoting formal
parameters within a @nt{formal_part} (see @RefSecNum{Subprogram Declarations}).
@end{Discussion}
@begin{Discussion}
The part about instances is from AI-00012.
The reason it says ``overloadable declarations'' is because we don't
want it to apply to type extensions that appear in an instance;
components are not overloadable.
@end{Discussion}
@end{Legality}

@begin{Notes}
Visibility for compilation units
follows from the definition of the environment
in @RefSecNum{The Compilation Process},
except that it is necessary to apply a @nt{with_clause} to obtain
visibility to a @nt{library_unit_declaration}
or @nt{library_unit_renaming_declaration}.

In addition to the visibility rules given above,
the meaning of the occurrence of a @nt{direct_name} or
@nt{selector_name} at a given place in the text can depend on
the overloading rules
(see @RefSecNum{The Context of Overload Resolution}).

Not all contexts where an @nt<identifier>, @nt<character_literal>,
or @nt<operator_symbol> are allowed require visibility of a corresponding
declaration.
Contexts where visibility is not required
are identified by using one of these three syntactic categories
directly in a syntax rule, rather than using @nt<direct_name> or
@nt<selector_name>.
@begin{Ramification}
An @nt{identifier}, @nt{character_literal} or @nt{operator_symbol}
that occurs in one of the following contexts is not
required to denote a visible or directly
visible declaration:
@begin{enumerate}
A defining name.

The @nt{identifier}s or @nt{operator_symbol} that appear after the
reserved word @key{end} in a @nt{proper_body}.
Similarly for ``@key{end loop}'', etc.

An @nt{attribute_designator}.

A @nt{pragma} @nt{identifier}.

A @SynI{pragma_argument_}@nt{identifier}.

An @nt{identifier} specific to a
pragma used in a pragma argument.
@end{enumerate}

The visibility rules have nothing to do with the above cases;
the meanings of such things are defined elsewhere.
Reserved words are not @nt{identifier}s;
the visibility rules don't apply to them either.

Because of the way we have defined "declaration",
it is possible for a usage name to denote a @nt{subprogram_body}, either
within that body, or (for a non-library unit) after it
(since the body hides the corresponding declaration, if any).
Other bodies do not work that way.
Completions of @nt{type_} and @nt{deferred_constant_declaration}s do
work that way.
@nt{Accept_statements} are never denoted, although the
@nt{parameter_specification}s in their profiles can be.

The scope of a subprogram does not start until after its profile.
Thus, the following is legal:
@begin{Example}
X : @key[constant] Integer := 17;
...
@key[package] P @key[is]
    @key[procedure] X(Y : @key[in] Integer := X);
@key[end] P;
@end{Example}

The body of the subprogram will probably be illegal,
however, since the constant X will be hidden by then.

The rule is different for generic subprograms,
since they are not overloadable;
the following is illegal:
@begin{Example}
X : @key[constant] Integer := 17;
@key[package] P @key[is]
    @key[generic]
      Z : Integer := X; --@RI{ Illegal!}
    @key[procedure] X(Y : @key[in] Integer := X); --@RI{ Illegal!}
@key[end] P;
@end{Example}

The constant X is hidden from direct visibility by the generic
declaration.
@end{Ramification}
@end{Notes}

@begin{Extend83}
Declarations with the same defining
name as that of a subprogram or entry being defined
are nevertheless visible within
the subprogram specification or entry declaration.
@end{Extend83}

@begin{DiffWord83}
The term ``visible by selection'' is no longer defined.
We use the terms ``directly visible'' and ``visible'' (among other things).
There are only two regions of text that are of interest, here: the
region in which a declaration is visible,
and the region in which it is directly visible.

Visibility is defined only for declarations.
@end{DiffWord83}

@LabeledClause{Use Clauses}

@begin{Intro}
@redundant[A @nt{use_package_clause} achieves direct visibility of declarations that
appear in the visible part of a package;
a @nt{use_type_clause} achieves direct visibility of the primitive
operators of a type.]
@end{Intro}

@begin{MetaRules}
@Defn{equivalence of @nt{use_clause}s and @nt{selected_component}s}
If and only if the visibility rules allow P.A,
"@key[use] P;" should make A directly visible
(barring name conflicts).
This means, for example, that child library units, and
generic formals of a formal package whose
@nt{formal_package_actual_part} is (<>),
should be made visible by
a @nt{use_clause} for the appropriate package.

@Defn{Beaujolais effect}
The rules for @nt{use_clause}s were carefully constructed to avoid
so-called @i(Beaujolais) effects, where the addition or removal
of a single @nt{use_clause}, or a single declaration in a "use"d
package, would
change the meaning of a program from one legal interpretation to another.
@end{MetaRules}

@begin{Syntax}
@Syn{lhs=<use_clause>,rhs="@Syn2{use_package_clause} | @Syn2{use_type_clause}"}


@Syn{lhs=<use_package_clause>,rhs="@key{use} @SynI{package_}@Syn2{name} {, @SynI{package_}@Syn2{name}};"}

@Syn{lhs=<use_type_clause>,rhs="@key{use type} @Syn2{subtype_mark} {, @Syn2{subtype_mark}};"}
@end{Syntax}

@begin{Legality}
A @SynI{package_}@nt{name} of a @nt{use_package_clause}
shall denote a package.
@begin{Ramification}
This includes formal packages.
@end{Ramification}
@end{Legality}

@begin{StaticSem}
@Defn2{Term=[scope], Sec=(of a @nt{use_clause})}
For each @nt{use_clause},
there is a certain region of text called the @i{scope} of the @nt{use_clause}.
For a @nt{use_clause} within a @nt{context_clause} of a
@nt{library_unit_declaration}
or @nt{library_unit_renaming_declaration},
the scope is the entire declarative region of the declaration.
For a @nt{use_clause} within a @nt{context_clause} of a
body, the scope is the entire body @Redundant[and any
subunits (including multiply
nested subunits).
The scope does not include @nt<context_clause>s themselves.]

For a @nt{use_clause} immediately within a declarative region,
the scope is the portion of the declarative region
starting just after the @nt{use_clause}
and extending to the end of the declarative region.
However, the scope of a @nt{use_clause} in the private part of a library
unit does not include the visible part of
any public descendant of that library unit.
@begin{Reason}
The exception echoes the similar exception for
``immediate scope (of a declaration)''
(see @RefSecNum{Scope of Declarations}).
It makes @nt{use_clause}s work like this:
@begin{Example}
@key[package] P @key[is]
    @key[type] T @key[is] @key[range] 1..10;
@key[end] P;

@key[with] P;
@key[package] Parent @key[is]
@key[private]
    @key[use] P;
    X : T;
@key[end] Parent;

@key[package] Parent.Child @key[is]
    Y : T; --@RI{ Illegal!}
    Z : P.T;
@key[private]
    W : T;
@key[end] Parent.Child;
@end{Example}

The declaration of Y is illegal because the scope of the ``@key[use] P''
does not include that place, so T is not directly visible there.
The declarations of X, Z, and W are legal.
@end{Reason}

@Defn{potentially use-visible}
For each package denoted by a @SynI{package_}@nt{name}
of a @nt{use_package_clause} whose scope encloses a place,
each declaration that occurs immediately within
the declarative region of the package is
@i(potentially) @i(use-visible) at this place
if the declaration is visible at this place.
@Comment{potentially and use-visible get separate i commands,
to prevent a Scribe bug that causes use-visible to not be italicized.}
For each type @i(T) or @i(T)'Class determined by a @nt<subtype_mark>
of a @nt{use_type_clause} whose scope encloses a place,
the declaration of each primitive operator of type @i(T)
is potentially use-visible
at this place
if its declaration is visible at this place.
  @begin{Ramification}
  Primitive subprograms whose defining name is an @nt{identifier} are
  @i{not} made potentially visible by a @nt{use_type_clause}.
  A @nt{use_type_clause} is only for operators.

  The semantics described here should be similar
  to the semantics for expanded names given
  in @RefSec{Selected Components}
  so as to achieve the effect requested by
  the ``principle of equivalence of @nt{use_clause}s and
  @nt{selected_component}s.''
  Thus, child library units and generic formal parameters of a formal
  package are
  potentially use-visible when their enclosing package is use'd.

  The "visible at that place" part implies that
  applying a @nt{use_clause} to a parent unit does not make all of its
  children use-visible @em only those that have been made
  visible by a @nt{with_clause}.
  It also implies that we don't have to worry about hiding in the
  definition of "directly visible" @em a declaration cannot be use-visible
  unless it is visible.

  Note that
  "@key[use type] T'Class;" is equivalent to "@key[use type] T;",
  which helps avoid breaking the generic contract model.
  @end{Ramification}

@Defn{use-visible}
@Defn2{Term=[visibility],Sec=(use clause)}
A declaration is @i{use-visible} if it is potentially use-visible,
except in these naming-conflict cases:
@begin{itemize}
  A potentially use-visible declaration is not use-visible if the place
  considered is within the immediate scope of a homograph of the
  declaration.

  Potentially use-visible declarations that have the same @nt{identifier}
  are not use-visible unless each of them is an overloadable
  declaration.
@begin{Ramification}
  Overloadable declarations don't cancel each other out,
  even if they are homographs,
  though if they are not distinguishable
  by formal parameter names or the presence or absence of
  @nt{default_expression}s, any use will be ambiguous.
  We only mention @nt{identifier}s here, because
  declarations named by @nt<operator_symbol>s are
  always overloadable, and hence never cancel each other.
  Direct visibility is irrelevant for @nt{character_literal}s.
@end{Ramification}
@end{itemize}
@end{StaticSem}

@begin{RunTime}
@PDefn2{Term=[elaboration], Sec=(use_clause)}
The elaboration of a @nt{use_clause} has no effect.
@end{RunTime}

@begin{Examples}

@i{Example of a use clause in a context clause:}
@begin{Example}
@key[with] Ada.Calendar; @key[use] Ada;
@end{Example}

@i{Example of a use type clause:}
@begin{Example}
@key[use type] Rational_Numbers.Rational; --@RI{ see @RefSecNum{Package Specifications and Declarations}}
Two_Thirds: Rational_Numbers.Rational := 2/3;
@end{Example}

@begin{Ramification}
In ``@key[use] X, Y;'', Y cannot refer to something made visible by the
``@key[use]'' of X.
Thus, it's not (quite) equivalent to ``@key[use] X; @key[use] Y;''.

If a given declaration is already immediately visible,
then a @nt{use_clause} that makes it potentially use-visible
has no effect.
Therefore,
a @nt{use_type_clause} for a type whose declaration appears
in a place other than the visible part
of a package has no effect;
it cannot make a declaration use-visible
unless that declaration is already immediately visible.

"@key[Use] @key[type] S1;" and "@key[use] @key[type] S2;"
are equivalent if S1 and S2 are both subtypes of the same type.
In particular,
"@key[use] @key[type] S;" and "@key[use] @key[type] S'Base;"
are equivalent.
@end{Ramification}
@begin{Reason}
We considered adding a rule that prevented several declarations of
views of the same entity that all have the same semantics from
cancelling each other out.
For example, if a (possibly implicit)
@nt{subprogram_declaration} for "+" is potentially use-visible,
and a fully conformant renaming of it is also potentially
use-visible, then they (annoyingly) cancel each other out;
neither one is use-visible.
The considered rule would have made just one of them use-visible.
We gave up on this idea due to the complexity of the rule.
It would have had to account for both overloadable and
non-overloadable @nt{renaming_declaration}s,
the case where the rule should apply only to some subset of the
declarations with the same defining name,
and the case of @nt{subtype_declaration}s
(since they are claimed to be sufficient for renaming of subtypes).
@end{Reason}
@end{Examples}

@begin{Extend83}
The @nt{use_type_clause} is new to Ada 9X.
@end{Extend83}

@begin{DiffWord83}
The phrase ``omitting from this set any packages that
enclose this place'' is no longer necessary to avoid making something
visible outside its scope, because we explicitly state that the
declaration has to be visible in order to be
potentially use-visible.
@end{DiffWord83}

@LabeledClause{Renaming Declarations}

@begin{Intro}
@redundant[A @nt{renaming_declaration} declares another name for an entity,
such as an object, exception, package, subprogram, entry,
or generic unit.
Alternatively, a @nt{subprogram_renaming_declaration} can be the
completion of a previous @nt{subprogram_declaration}.]
@end{Intro}

@begin{Syntax}
@Syn{lhs=<renaming_declaration>,rhs="
      @Syn2{object_renaming_declaration}
    | @Syn2{exception_renaming_declaration}
    | @Syn2{package_renaming_declaration}
    | @Syn2{subprogram_renaming_declaration}
    | @Syn2{generic_renaming_declaration}"}
@end{Syntax}

@begin{RunTime}
@PDefn2{Term=[elaboration], Sec=(renaming_declaration)}
The elaboration of a @nt{renaming_declaration} evaluates the @nt{name} that
follows the reserved word @key{renames} and thereby determines the
view and entity denoted by this name
@Defn{renamed view}
@Defn{renamed entity}
(the @i{renamed view} and @i{renamed entity}).
@Redundant[A @nt{name} that denotes the @nt{renaming_declaration}
denotes (a new view of) the renamed entity.]
@end{RunTime}

@begin{Notes}
Renaming may be used to resolve name conflicts and to act as a
shorthand.  Renaming with a different @nt{identifier} or
@nt{operator_symbol} does not hide the old @nt{name}; the new
@nt{name} and the old @nt{name} need not be visible at the same
places.

A task or protected object that is declared by an explicit
@nt{object_declaration} can be renamed as an object.  However, a
single task or protected object cannot be renamed since the
corresponding type is anonymous (meaning it has no nameable subtypes).
For similar reasons, an object of an anonymous array or access type
cannot be renamed.

A subtype defined without any additional constraint
can be used to achieve the effect of renaming another subtype
(including a task or protected subtype) as in
@begin{Example}
@key[subtype] Mode @key[is] Ada.Text_IO.File_Mode;
@end{Example}
@end{Notes}

@begin{DiffWord83}
The second sentence of RM83-8.5(3),
``At any point where a renaming declaration is visible,
the identifier, or operator symbol of this declaration denotes the
renamed entity.''
is incorrect.
It doesn't say directly visible.
Also, such an @nt{identifier} might resolve to something else.

The verbiage about renamings being legal ``only if exactly one...'',
which appears in RM83-8.5(4) (for objects)
and RM83-8.5(7) (for subprograms) is removed,
because it follows from the normal rules about overload resolution.
For language lawyers, these facts are obvious;
for programmers, they are irrelevant,
since failing these tests is highly unlikely.
@end{DiffWord83}

@LabeledSubClause{Object Renaming Declarations}

@begin{Intro}
@redundant[An @nt{object_renaming_declaration} is used to rename an object.]
@end{Intro}

@begin{Syntax}
@Syn{lhs=<object_renaming_declaration>,rhs="@Syn2{defining_identifier} : @Syn2{subtype_mark} @key{renames} @SynI{object_}@Syn2{name};"}
@end{Syntax}

@begin{Resolution}

The type of the @SynI{object_}@nt{name} shall resolve to
the type determined by the @nt{subtype_mark}.

@begin{Reason}

A previous version of Ada 9X used the usual ``expected type''
wording:
``The expected type for the @SynI{object_}@nt{name} is
that determined by the @nt{subtype_mark}.''
We changed it so that this would be illegal:
@begin{Example}
X: T;
Y: T'Class @key[renames] X; --@RI{ Illegal!}
@end{Example}

When the above was legal, it was unclear whether Y
was of type T or T'Class.
Note that we still allow this:
@begin{Example}
Z: T'Class := ...;
W: T @key[renames] F(Z);
@end{Example}

where F is a function with a controlling parameter and result.
This is admittedly a bit odd.

Note that the matching rule for generic formal parameters of mode
@key[in out] was changed to keep it consistent with the rule
for renaming.
That makes the rule different for @key[in] vs. @key[in out].

@end{Reason}
@end{Resolution}

@begin{Legality}
The renamed entity shall be an object.

The renamed entity shall not be a subcomponent that
depends on discriminants of a variable whose
nominal subtype is unconstrained,
unless this subtype is indefinite,
or the variable is aliased.
A @nt{slice} of an array shall not be renamed if
this restriction disallows renaming of the array.
@begin{Reason}
This prevents renaming of subcomponents that might
disappear, which might leave dangling references.
Similar restrictions exist for the Access attribute.
@end{Reason}
@begin{ImplNote}
Note that if an implementation chooses to deallocate-then-reallocate
on @nt{assignment_statement}s assigning to unconstrained definite objects,
then it cannot represent renamings and access values as simple
addresses, because the above rule does not apply to all components of
such an object.
@end{ImplNote}
@begin{Ramification}
If it is a generic formal object,
then the assume-the-best or assume-the-worst rules are applied as
appropriate.
@end{Ramification}
@end{Legality}

@begin{StaticSem}
An @nt{object_renaming_declaration} declares a new view
@Redundant{of the renamed object} whose
properties are identical to those of the renamed view.
@Redundant[Thus, the properties of the renamed object are not affected by the
@nt{renaming_declaration}.
In particular, its value and whether or not it is a constant
are unaffected; similarly, the constraints that apply to an object are
not affected by renaming (any constraint implied by the
@nt{subtype_mark} of the @nt{object_renaming_declaration}
is ignored).]
@begin{Discussion}
Because the constraints are ignored,
it is a good idea
to use the nominal subtype of the renamed object
when writing an @nt{object_renaming_declaration}.
@end{Discussion}
@end{StaticSem}

@begin{Examples}
@i{Example of renaming an object:}
@begin{Example}
@key[declare]
   L : Person @key[renames] Leftmost_Person; --@RI{ see @RefSecNum{Incomplete Type Declarations}}
@key[begin]
   L.Age := L.Age + 1;
@key[end];
@end{Example}
@end{Examples}

@begin{DiffWord83}
The phrase ``subtype ... as defined in a corresponding
object declaration, component declaration, or component subtype
indication,'' from RM83-8.5(5), is incorrect in Ada 9X;
therefore we removed it.
It is incorrect in the case of an object with an indefinite
unconstrained nominal subtype.
@end{DiffWord83}

@LabeledSubClause{Exception Renaming Declarations}

@begin{Intro}
@redundant[An @nt{exception_renaming_declaration} is used to rename an exception.]
@end{Intro}

@begin{Syntax}
@Syn{lhs=<exception_renaming_declaration>,rhs="@Syn2{defining_identifier} : @key{exception} @key{renames} @SynI{exception_}@Syn2{name};"}
@end{Syntax}

@begin{Legality}
The renamed entity shall be an exception.
@end{Legality}

@begin{StaticSem}
An @nt{exception_renaming_declaration} declares a new view
@Redundant{of the renamed exception}.
@end{StaticSem}

@begin{Examples}
@i{Example of renaming an exception:}
@begin{Example}
EOF : @key[exception] @key[renames] Ada.IO_Exceptions.End_Error;@RI{-- see @RefSecNum{Exceptions in Input-Output}}
@end{Example}
@end{Examples}

@LabeledSubClause{Package Renaming Declarations}

@begin{Intro}
@redundant[A @nt{package_renaming_declaration} is used to rename a package.]
@end{Intro}

@begin{Syntax}
@Syn{lhs=<package_renaming_declaration>,rhs="@key{package} @Syn2{defining_program_unit_name} @key{renames} @SynI{package_}@Syn2{name};"}
@end{Syntax}

@begin{Legality}
The renamed entity shall be a package.
@end{Legality}

@begin{StaticSem}
A @nt{package_renaming_declaration} declares a new view
@Redundant{of the renamed package}.
@end{StaticSem}

@begin{Examples}
@i{Example of renaming a package:}
@begin{Example}
@key[package] TM @key[renames] Table_Manager;
@end{Example}
@end{Examples}

@LabeledSubClause{Subprogram Renaming Declarations}

@begin{Intro}
A @nt{subprogram_renaming_declaration} can serve as the completion of
a @nt{subprogram_declaration};
@Defn{renaming-as-body}
such a @nt{renaming_declaration} is called a @i{renaming-as-body}.
@Defn{renaming-as-declaration}
A @nt{subprogram_renaming_declaration} that is not a completion is
called a @i{renaming-as-declaration}@Redundant[,
and is used to rename a subprogram
(possibly an enumeration literal) or an entry].
@begin{Ramification}
A renaming-as-body is a declaration,
as defined in Section 3.
@end{Ramification}
@end{Intro}

@begin{Syntax}
@Syn{lhs=<subprogram_renaming_declaration>,rhs="@Syn2{subprogram_specification} @key{renames} @SynI{callable_entity_}@Syn2{name};"}
@end{Syntax}

@begin{Resolution}
@PDefn2{Term=[expected profile],
  Sec=(subprogram_renaming_declaration)}
The expected profile for the @i(callable_entity_)@nt<name>
is the profile given in the @nt<subprogram_specification>.
@end{Resolution}

@begin{Legality}
The profile of a renaming-as-declaration
shall be mode-conformant with that of the renamed callable entity.
@Defn2{Term=[mode conformance],Sec=(required)}

The profile of a renaming-as-body
shall be subtype-conformant with that of the renamed callable entity,
and shall conform fully to that of the declaration it completes.
@Defn2{Term=[subtype conformance],Sec=(required)}
@Defn2{Term=[full conformance],Sec=(required)}
If the renaming-as-body completes that declaration
before the subprogram it declares is
frozen, the subprogram it declares takes its convention
from the renamed subprogram;
otherwise the convention of the renamed subprogram shall not be
Intrinsic.
@begin{Reason}
The first part of the first sentence is to allow an
implementation of a renaming-as-body
as a single jump instruction to the target subprogram.
Among other things, this prevents a subprogram from being completed with
a renaming of an entry.
(In most cases, the target of the jump can be filled in at link time.
In some cases, such as a renaming of a name like
"A(I).@key[all]", an indirect jump is needed.
Note that the name is evaluated at renaming time, not at call
time.)

The second part of the first sentence is
the normal rule for completions of
@nt{subprogram_declaration}s.
@end{Reason}
@begin{Ramification}
An @nt{entry_declaration}, unlike a @nt{subprogram_declaration},
cannot be completed with a @nt{renaming_declaration}.
Nor can a @nt{generic_subprogram_declaration}.


The syntax rules prevent a protected subprogram declaration from being
completed by a renaming.
This is fortunate, because it allows us to avoid worrying about whether
the implicit protected object parameter of a protected operation is
involved in the conformance rules.

@end{Ramification}

A @nt{name} that denotes a formal parameter
of the @nt{subprogram_specification}
is not allowed within the @i{callable_entity_}@nt{name}.
@begin{Reason}
This is to prevent things like this:
@begin{Example}
@key[function] F(X : Integer) @key[return] Integer @key[renames] Table(X).@key[all];
@end{Example}

A similar rule in @RefSecNum{Subprogram Declarations}
forbids things like this:
@begin{Example}
@key[function] F(X : Integer; Y : Integer := X) @key[return] Integer;
@end{Example}
@end{Reason}
@end{Legality}

@begin{StaticSem}
A renaming-as-declaration
declares a new view of the renamed entity.
The profile of this new view takes its subtypes, parameter modes,
and calling convention
from the original profile of the
callable entity, while taking the formal parameter
@nt{name}s and @nt{default_expression}s from the profile given in the
@nt{subprogram_renaming_declaration}.
The new view is a function or procedure,
never an entry.
@begin{Honest}
When renaming an entry as a procedure,
the compile-time rules apply as if the new view is a procedure,
but the run-time semantics of a call are that of an entry call.
@end{Honest}
@begin{Ramification}
For example, it is illegal for the @nt{entry_call_statement} of a
@nt{timed_entry_call} to call the new view.
But what looks like a procedure call will do things like barrier
waiting.
@end{Ramification}
@end{StaticSem}

@begin{RunTime}
For a call on a renaming of a dispatching subprogram that is
overridden,
if the overriding occurred before the renaming, then the body executed
is that of the overriding declaration,
even if the overriding declaration is not visible at the place of the
renaming;
otherwise, the inherited or predefined subprogram is called.
@begin{Discussion}
Note that whether or not the renaming is itself primitive has
nothing to do with the renamed subprogram.

Note that the above rule is only for tagged types.

Consider the following example:
@begin{Example}
@key[package] P @key[is]
    @key[type] T @key[is] @key[tagged] @key[null] @key[record];
    @key[function] Predefined_Equal(X, Y : T) @key[return] Boolean @key[renames] "=";
@key[private]
    @key[function] "="(X, Y : T) @key[return] Boolean; --@RI{ Override predefined "=".}
@key[end] P;

@key[with] P; @key[use] P;
@key[package] Q @key[is]
    @key[function] User_Defined_Equal(X, Y : T) @key[return] Boolean @key[renames] P."=";
@key[end] Q;
@end{Example}

A call on Predefined_Equal will execute the predefined equality operator
of T, whereas a call on User_Defined_Equal will execute the body of the
overriding declaration in the private part of P.

Thus a renaming allows one to squirrel away a copy of an inherited or
predefined subprogram before later overriding it.
@Defn2{Term=[squirrel away],Sec=(included in fairness to alligators)}
@end{Discussion}
@end{RunTime}

@begin{Notes}
A procedure can only be renamed as a procedure.
A function whose @nt{defining_designator} is either an
@nt{identifier} or an @nt{operator_symbol}
can be renamed with either an
@nt{identifier} or an @nt{operator_symbol};
for renaming as an operator, the subprogram specification given in
the @nt{renaming_declaration} is subject to the rules given in
@RefSecNum{Overloading of Operators}
for operator declarations.  Enumeration literals can be
renamed as functions; similarly, @nt{attribute_reference}s that
denote functions (such as references to Succ and Pred) can be renamed
as functions.  An entry can only be renamed as a procedure; the new
@nt{name} is only allowed to appear in contexts that allow a
procedure @nt{name}.  An entry of a family can be renamed, but an
entry family cannot be renamed as a whole.


The operators of the root numeric types cannot be renamed because the
types in the profile are anonymous, so the corresponding specifications
cannot be written; the same holds for certain attributes, such as Pos.


Calls with the new @nt{name} of a renamed entry are
@nt{procedure_call_statement}s and are not allowed at places
where the syntax requires an @nt{entry_call_statement} in
@nt{conditional_} and @nt{timed_entry_call}s,
nor in an @nt{asynchronous_select}; similarly, the Count
attribute is not available for the new @nt{name}.

The primitiveness of a renaming-as-declaration is determined by its
profile, and by where it occurs, as for any declaration of
(a view of) a subprogram;
primitiveness is not determined by the renamed view.
In order to perform a dispatching call,
the subprogram name has to denote a primitive subprogram,
not a non-primitive renaming of a primitive subprogram.
@begin{Reason}
A @nt{subprogram_renaming_declaration} could more properly be called
@nt{renaming_as_subprogram_declaration}, since you're renaming something
as a subprogram, but you're not necessarily renaming a subprogram.
But that's too much of a mouthful.
Or, alternatively, we could call it a
@nt{callable_entity_renaming_declaration}, but that's even worse.
Not only is it a mouthful,
it emphasizes the entity being renamed,
rather than the new view, which we think is a bad idea.
We'll live with the oddity.
@end{Reason}
@end{Notes}

@begin{Examples}
@i{Examples of subprogram renaming declarations:}
@begin{Example}
@key[procedure] My_Write(C : @key[in] Character) @key[renames] Pool(K).Write; --@RI{  see @RefSecNum{Selected Components}}

@key[function] Real_Plus(Left, Right : Real   ) @key[return] Real    @key[renames] "+";
@key[function] Int_Plus (Left, Right : Integer) @key[return] Integer @key[renames] "+";

@key[function] Rouge @key[return] Color @key[renames] Red;  --@RI{  see @RefSecNum{Enumeration Types}}
@key[function] Rot   @key[return] Color @key[renames] Red;
@key[function] Rosso @key[return] Color @key[renames] Rouge;

@key[function] Next(X : Color) @key[return] Color @key[renames] Color'Succ; --@RI{ see @RefSecNum{Enumeration Types}}
@end{Example}

@i{Example of a subprogram renaming declaration with new parameter names:}
@begin{Example}
@key[function] "*" (X,Y : Vector) @key[return] Real @key[renames] Dot_Product; --@RI{ see @RefSecNum{Subprogram Declarations}}
@end{Example}

@i{Example of a subprogram renaming declaration with a new default expression:}
@begin{Example}
@key[function] Minimum(L : Link := Head) @key[return] Cell @key[renames] Min_Cell; --@RI{ see @RefSecNum{Subprogram Declarations}}
@end{Example}
@end{Examples}

@LabeledSubClause{Generic Renaming Declarations}

@begin{Intro}
@redundant[A @nt{generic_renaming_declaration} is used to rename a generic unit.]
@end{Intro}

@begin{Syntax}
@Syn{tabs=[P22], lhs=<generic_renaming_declaration>,rhs="
    @key{generic package}@\@Syn2{defining_program_unit_name} @key{renames} @SynI{generic_package_}@Syn2{name};
  | @key{generic procedure}@\@Syn2{defining_program_unit_name} @key{renames} @SynI{generic_procedure_}@Syn2{name};
  | @key{generic function}@\@Syn2{defining_program_unit_name} @key{renames} @SynI{generic_function_}@Syn2{name};"}
@end{Syntax}

@begin{Legality}
The renamed entity shall be a generic unit of the corresponding kind.
@end{Legality}

@begin{StaticSem}
A @nt{generic_renaming_declaration} declares a new view
@Redundant{of the renamed generic unit}.
@end{StaticSem}

@begin{Notes}
Although the properties of the new view are the same as those of the
renamed view, the place where the @nt<generic_renaming_declaration> occurs
may affect the legality of subsequent renamings and instantiations
that denote the @nt<generic_renaming_declaration>,
in particular if the renamed generic unit is a library unit
(see @RefSecNum{Compilation Units - Library Units}).
@end{Notes}

@begin{Examples}
@i{Example of renaming a generic unit:}
@begin{Example}
@key[generic package] Enum_IO @key[renames] Ada.Text_IO.Enumeration_IO;  @RI{-- see @RefSecNum{Input-Output for Enumeration Types}}
@end{Example}
@end{Examples}

@begin{Extend83}
Renaming of generic units is new to Ada 9X.
It is particularly important for renaming child library
units that are generic units.  For example, it might
be used to rename Numerics.Generic_Elementary_Functions as simply
Generic_Elementary_Functions, to match the name for
the corresponding Ada-83-based package.
@end{Extend83}

@begin{DiffWord83}
The information in RM83-8.6, ``The Package Standard,''
has been updated for the child unit feature,
and moved to @RefSecNum{Predefined Language Environment},
except for the definition of ``predefined type,''
which has been moved to @RefSecNum{Type Declarations}.
@end{DiffWord83}

@LabeledClause{The Context of Overload Resolution}

@begin{Intro}
@redundant[@Defn{overload resolution}
Because declarations can be overloaded,
it is possible for an occurrence of a usage name
to have more than one possible interpretation;
in most cases, ambiguity is disallowed.
This clause describes how the possible interpretations resolve
to the actual interpretation.

@Defn{overloading rules}
Certain rules of the language (the @ResolutionTitle)
are considered ``overloading rules''.
If a possible interpretation violates an overloading rule,
it is assumed not to be the intended interpretation;
some other possible interpretation
is assumed to be the actual interpretation.
On the other hand,
violations of non-overloading rules do not affect which
interpretation is chosen; instead,
they cause the construct to be illegal.
To be legal, there usually has to be exactly one acceptable
interpretation of a construct that is a ``complete context'',
not counting any nested complete contexts.

@Defn2{Term=[grammar],Sec=(resolution of ambiguity)}
The syntax rules of the language and the visibility rules
given in @RefSecNum{Visibility}
determine the possible interpretations.
Most type checking rules
(rules that require a particular type,
or a particular class of types,
for example)
are overloading rules.
Various rules for the matching of formal and actual parameters are
overloading rules.]
@end{Intro}

@begin{MetaRules}
The type resolution rules are
intended to minimize the need for implicit declarations
and preference rules associated with implicit conversion and dispatching
operations.
@end{MetaRules}

@begin{Resolution}
@Defn{complete context}
@Redundant{Overload resolution is applied separately to each
@i{complete context},
not counting inner complete contexts.}
Each of the following constructs is a @i{complete context}:
@begin{itemize}
A @nt{context_item}.

A @nt{declarative_item} or declaration.
@begin{Ramification}
A @nt{loop_parameter_specification} is a declaration,
and hence a complete context.
@end{Ramification}

A @nt{statement}.

A @nt{pragma_argument_association}.
@begin{Reason}
  We would make it the whole @nt{pragma},
  except that certain pragma arguments are allowed to be ambiguous,
  and ambiguity applies to a complete context.
@end{Reason}

The @nt{expression} of a @nt{case_statement}.
@begin{Ramification}
  This means that the @nt{expression} is resolved without looking
  at the choices.
@end{Ramification}
@end{itemize}

@Defn2{Term=[interpretation], Sec=(of a complete context)}
@Defn2{Term=[overall interpretation], Sec=(of a complete context)}
An (overall) @i{interpretation} of a complete context
embodies its meaning, and includes
the following information about the constituents of the complete
context,
not including constituents of inner complete contexts:
@begin{Itemize}
for each constituent of the complete context,
to which syntactic categories it belongs,
and by which syntax rules; and
@begin{Ramification}
Syntactic categor@i{ies} is plural here,
because there are lots of trivial productions @em
an @nt{expression} might also be all of the following,
in this order: @nt{identifier},
@nt{name},
@nt{primary},
@nt{factor},
@nt{term},
@nt{simple_expression}, and
@nt{relation}.
Basically, we're trying to capture all the information in the parse tree
here, without using compiler-writer's jargon like ``parse tree''.
@end{Ramification}

for each usage name, which declaration it denotes
(and, therefore, which view and which entity it denotes); and
@begin{Ramification}
In most cases, a usage name denotes the view declared by the denoted
declaration.
However, in certain cases, a usage name that denotes a declaration and
appears inside the declarative region of that same declaration, denotes
the current instance of the declaration.
For example, within a @nt{task_body}, a usage name that denotes the
@nt{task_type_declaration} denotes the object containing the
currently executing task,
and not the task type declared by the declaration.
@end{Ramification}

for a complete context that is a @nt{declarative_item},
whether or not it is a completion of a declaration,
and (if so) which declaration it completes.
@end{Itemize}
@begin{Ramification}
Unfortunately, we are not confident that the above list is complete.
We'll have to live with that.
@end{Ramification}
@begin{Honest}
For ``possible'' interpretations, the above information is tentative.
@end{Honest}
@begin{Discussion}
A possible interpretation (an @i{input} to overload
resolution) contains information about what a
usage name @i{might} denote, but what it actually @i{does} denote
requires overload resolution to determine.
Hence the term ``tentative'' is needed for possible interpretations;
otherwise, the definition would be circular.
@end{Discussion}

@Defn{possible interpretation}
A @i{possible interpretation} is one
that obeys the syntax rules and the visibility rules.
@Defn{acceptable interpretation}
@Defn2{Term=[resolve],Sec=(overload resolution)}
@Defn2{Term=[interpretation],Sec=(overload resolution)}
An @i{acceptable interpretation} is a possible interpretation that
obeys the @i{overloading rules}@Redundant{,
that is, those rules that specify an expected type or
expected profile, or specify how a construct shall @i(resolve)
or be @i(interpreted).}
@begin{Honest}
One rule that falls into this category,
but does not use the above-mentioned magic words,
is the rule about numbers of parameter associations in a call
(see @RefSecNum{Subprogram Calls}).
@end{Honest}
@begin{Ramification}
The @ResolutionName@;s are the ones that appear under the
@ResolutionTitle heading.
Some @SyntaxName@;s are written in English, instead of BNF.
No rule is a @SyntaxName or @ResolutionName unless it appears under the
appropriate heading.
@end{Ramification}

@Defn2{Term=[interpretation], Sec=(of a constituent of a complete context)}
The @i{interpretation} of a constituent of a complete context is
determined from the overall interpretation of the complete context as a
whole.
@Redundant{Thus,
for example, ``interpreted as a @nt{function_call},''
means that the construct's interpretation says that it belongs
to the syntactic category @nt{function_call}.}

@Defn{denote}
@Redundant[Each occurrence of]
a usage name @i{denotes} the declaration determined by its
interpretation.
It also denotes the view declared by its denoted
declaration, except in the following cases:
@begin{Ramification}
As explained below, a pragma argument is allowed to be ambiguous,
so it can denote several declarations,
and all of the views declared by those declarations.
@end{Ramification}
@begin(itemize)
  @Defn2{Term=[current instance], Sec=(of a type)}
  If a usage name appears within the declarative region of a
  @nt{type_declaration} and denotes that same @nt{type_declaration},
  then it denotes the @i{current instance} of the type (rather than
  the type itself).
  The current instance of a type is the object or value
  of the type that is associated with the execution that
  evaluates the usage name.
  @begin{Reason}
  This is needed, for example, for references to the Access attribute
  from within the @nt{type_declaration}.
  Also, within a @nt{task_body} or @nt{protected_body},
  we need to be able to denote the current task or protected object.
  (For a @nt{single_task_declaration} or
  @nt{single_protected_declaration}, the rule about current instances
  is not needed.)
  @end{Reason}

  @Defn2{Term=[current instance], Sec=(of a generic unit)}
  If a usage name appears within the declarative region of a
  @nt{generic_declaration} (but not within its @nt{generic_formal_part})
  and it denotes that same @nt{generic_declaration}, then it
  denotes the @i{current instance} of the generic unit (rather than
  the generic unit itself).
  See also @RefSecNum{Generic Instantiation}.
  @begin{Honest}
    The current instance of a generic unit is the instance created
    by whichever @nt{generic_instantiation} is of interest at any
    given time.
  @end{Honest}
  @begin{Ramification}
    Within a @nt{generic_formal_part}, a @nt{name} that denotes the
    @nt{generic_declaration} denotes the generic unit,
    which implies that it is not overloadable.
  @end{Ramification}
@end(itemize)

A usage name that denotes a view also denotes the entity of that view.
@begin{Ramification}
Usually, a usage name denotes only one declaration,
and therefore one view and one entity.
@end{Ramification}

@RootDefn[expected type]
The @i(expected type) for a given @nt<expression>, @nt<name>,
or other construct determines, according to the @i{type resolution
rules} given below, the types considered for the construct during
overload resolution.
@Defn{type resolution rules}
@Redundant[
The type resolution rules provide support for class-wide programming,
universal numeric literals, dispatching operations, and
anonymous access types:]
@begin{Ramification}
  Expected types are defined throughout the RM9X.
  The most important definition is that, for a
  subprogram, the expected type for the
  actual parameter is the type of the formal parameter.

  The type resolution rules are trivial unless either the
  actual or expected type is universal, class-wide, or of
  an anonymous access type.
@end{Ramification}
@begin{Itemize}
@PDefn2{Term=[type resolution rules],
  Sec=(if any type in a specified class of types is expected)}
@PDefn2{Term=[type resolution rules],
  Sec=(if expected type is universal or class-wide)}
If a construct is expected to be of any type in a class of types,
or of the universal or class-wide type for a class,
then the type of the construct shall resolve to a type in that class
or to a universal type that covers the class.
@begin{Ramification}
This matching rule handles (among other things) cases like the
Val attribute, which denotes a function that takes a parameter of type
@i(universal_integer).

The last part of the rule,
``or to a universal type that includes the class''
implies that if the expected type for an expression
is @i{universal_fixed},
then an expression whose type is @i{universal_real}
(such as a real literal) is OK.
@end{Ramification}

@PDefn2{Term=[type resolution rules],
  Sec=(if expected type is specific)}
If the expected type for a construct is a specific type @i(T), then the type
of the construct shall resolve either to @i(T), or:
@begin{Ramification}
@PDefn{Beaujolais effect}
This rule is @i{not} intended to create a preference for the specific
type @em such a preference would cause Beaujolais effects.
@end{Ramification}
@begin(itemize)
    to @i(T)'Class; or
@begin{Ramification}
      This will only be legal as part of a call on a dispatching operation;
      see @RefSec(Dispatching Operations of Tagged Types).
      Note that that rule is not a @ResolutionName.
@end{Ramification}

    to a universal type that covers @i(T); or

    when @i(T) is an anonymous access type
    (see @RefSecNum{Access Types}) with designated type @i(D),
    to an access-to-variable type
    whose designated type is @i(D)'Class or is covered by @i(D).
@begin{Ramification}
      Because it says ``access-to-variable'' instead of ``access-to-object,''
      two subprograms that differ only in that one has a parameter
      of an access-to-constant type,
      and the other has an access parameter, are distinguishable
      during overload resolution.

      The case where the actual is access-to-@i(D)'Class will only
      be legal as part of a call on a dispatching operation;
      see @RefSec(Dispatching Operations of Tagged Types).
      Note that that rule is not a @ResolutionName.
@end{Ramification}
@end(itemize)
@end{Itemize}

@RootDefn[expected profile]
In certain contexts,
@Redundant[such as in a @nt{subprogram_renaming_declaration},]
the @ResolutionTitle define an @i(expected profile) for a given
@nt<name>;
@Defn2{Term=[profile resolution rule],
  Sec=(@nt<name> with a given expected profile)}
in such cases, the @nt{name}
shall resolve to the name of a callable entity whose profile is type
conformant with the expected profile.
@Defn2{Term=[type conformance],Sec=(required)}
@begin{Ramification}
  The parameter and result @i{sub}types are not used in overload
  resolution.
  Only type conformance of profiles
  is considered during overload resolution.
  Legality rules generally require at least mode-conformance
  in addition, but those rules are not used in overload resolution.
@end{Ramification}
@end{Resolution}

@begin{Legality}
@Defn2{Term=[single], Sec=[class expected type]}
When the expected type for a construct is required
to be a @i(single) type in a given class,
the type expected for the construct shall be determinable solely
from the context in which the construct appears,
excluding the construct itself,
but using the requirement that it be in the given class;
the type of the construct is then this single expected type.
Furthermore, the context shall not be one that expects any type in
some class that contains types of the given class;
in particular, the construct shall not be the operand of a
@nt{type_conversion}.
@begin{Ramification}
For example, the expected type for the literal @key{null} is required to be a
single access type.
But the expected type for the operand of a @nt{type_conversion} is
any type.
Therefore, the literal @key{null} is not allowed as the operand of a
@nt{type_conversion}.
This is true even if there is only one access type in scope.
The reason for these rules is so that the compiler will not have to
search ``everywhere'' to see if there is exactly one type in a class
in scope.
@end{Ramification}

A complete context shall have at least one acceptable
interpretation;
if there is exactly one,
then that one is chosen.
@begin{Ramification}
This, and the rule below
about ambiguity, are the ones that suck in all the @SyntaxName@;s and
@ResolutionName@;s as compile-time rules.
Note that this and the ambiguity rule have to be @LegalityName@;s.
@end{Ramification}

@Defn2{Term=[preference], Sec=(for root numeric operators and @nt<range>s)}
There is a @i{preference} for the primitive operators (and @nt<range>s)
of the root numeric
types @i{root_integer} and @i{root_real}.
In particular,
if two acceptable interpretations of a constituent of a complete
context differ only in that one is for a primitive operator (or
@nt<range>) of the
type @i{root_integer} or @i{root_real}, and the other is not,
the interpretation using the primitive operator (or @nt<range>)
of the root numeric type is @i{preferred}.
@begin{Reason}
The reason for this preference is so that expressions involving literals
and named numbers can be unambiguous.
For example, without the preference rule,
the following would be ambiguous:
@begin{Example}
N : @key[constant] := 123;
@key[if] N > 100 @key[then] --@RI{ Preference for root_integer "<" operator.}
    ...
@key[end] @key[if];
@end{Example}
@end{Reason}

For a complete context, if there is exactly one
overall acceptable interpretation where each constituent's interpretation
is the same as or preferred (in the
above sense) over those in all other overall acceptable interpretations, then
that one overall acceptable interpretation is chosen.
@Defn{ambiguous}
Otherwise,
the complete context is @i{ambiguous}.

A complete context other than a @nt{pragma_argument_association}
shall not be ambiguous.

A complete context that is a @nt{pragma_argument_association}
is allowed to be ambiguous (unless otherwise specified
for the particular pragma),
but only
if every acceptable interpretation of the pragma argument is as a
@nt{name} that statically denotes a callable entity.
@PDefn2{Term=[denote],Sec=(name used as a pragma argument)}
Such a @nt{name} denotes
all of the declarations determined by its interpretations,
and all of the views declared by these declarations.
@begin{Ramification}
This applies to Inline, Suppress,
Import, Export, and Convention @nt{pragma}s.
For example, it is OK to say ``@key[pragma] Suppress(Elaboration_Check, On
=> P.Q);'', even if there are two directly visible P's, and
there are two Q's declared in the visible part of each P.
In this case, P.Q denotes four different declarations.
This rule also applies to certain pragmas defined in the
Specialized Needs Annexes.
It almost applies to Pure, Elaborate_Body, and Elaborate_All @nt{pragma}s,
but those can't have overloading for other reasons.

Note that if a pragma argument denotes a @i{call} to a callable
entity, rather than the entity itself,
this exception does not apply, and ambiguity is disallowed.

Note that we need to carefully define which pragma-related rules are
@ResolutionName@;s,
so that, for example, a @nt{pragma} Inline does not pick up
subprograms declared in enclosing declarative regions,
and therefore make itself illegal.

We say ``statically denotes'' in the above rule in order to avoid
having to worry about how many times the @nt{name} is evaluated,
in case it denotes more than one callable entity.
@end{Ramification}
@end{Legality}

@begin{Notes}
If a usage name has only one acceptable interpretation,
then it denotes the corresponding entity.
However, this does not mean that the usage name is necessarily legal
since other requirements exist which are not considered for overload
resolution; for example, the fact that an expression is static, whether
an object is constant, mode and subtype conformance rules, freezing
rules, order of elaboration, and so on.

@NoPrefix@;Similarly, subtypes are not considered for overload resolution (the
violation of a constraint does not make a program illegal but raises an
exception during program execution).
@end{Notes}

@begin{Incompatible83}
@PDefn{Beaujolais effect}
The new preference rule for operators of root numeric types
is upward incompatible,
but only in cases that involved @i(Beaujolais) effects in Ada 83.
Such cases are ambiguous in Ada 9X.
@end{Incompatible83}

@begin{Extend83}
The rule that allows an expected type to match an actual expression of a
universal type,
in combination with the new preference rule for operators of root numeric
types, subsumes the Ada 83 "implicit conversion" rules
for universal types.
@end{Extend83}

@begin{DiffWord83}
In Ada 83, it is not clear what the ``syntax rules'' are.
AI-00157 states that a certain textual rule is a syntax rule,
but it's still not clear how one tells in general which textual rules are
syntax rules.
We have solved the problem by stating exactly which
rules are syntax rules @em the ones that appear under the ``@SyntaxTitle''
heading.

RM83 has a long list of the ``forms'' of rules that are to be
used in overload resolution (in addition to the syntax rules).
It is not clear exactly which rules fall under each form.
We have solved the problem by explicitly
marking all rules that are used in overload resolution.
Thus, the list of kinds of rules is unnecessary.
It is replaced with some introductory
(intentionally vague)
text explaining the basic idea
of what sorts of rules are overloading rules.

It is not clear from RM83 what information is embodied in a ``meaning''
or an ``interpretation.''
``Meaning'' and ``interpretation'' were intended to be synonymous;
we now use the latter only in defining the rules about overload
resolution.
``Meaning'' is used only informally.
This clause attempts to clarify what is meant by ``interpretation.''

@NoPrefix@;For example,
RM83 does not make it clear that overload resolution is required in
order to match @nt{subprogram_bodies} with their corresponding
declarations (and even to tell whether a given @nt{subprogram_body}
is the completion of a previous declaration).
Clearly, the information needed to do this is part of the
``interpretation'' of a @nt{subprogram_body}.
The resolution of such things is defined in terms of
the ``expected profile'' concept.
Ada 9X has some new cases where expected profiles
are needed @em the resolution of P'Access,
where P might denote a subprogram,
is an example.

@NoPrefix@;RM83-8.7(2) might seem to imply that an interpretation embodies
information about what is denoted by each usage name,
but not information about which syntactic category each construct
belongs to.
However, it seems necessary to include such information,
since the Ada grammar is highly ambiguous.
For example, X(Y) might be a @nt{function_call} or an
@nt{indexed_component}, and no context-free/syntactic information can
tell the difference.
It seems like we should view X(Y) as being, for example, ``interpreted as a
@nt{function_call}'' (if that's what overload resolution decides it is).
Note that there are examples where the denotation of each usage name
does not imply the syntactic category.
However, even if that were not true, it seems that intuitively,
the interpretation includes that information.
Here's an example:
@begin{Example}
@key[type] T;
@key[type] A @key[is] @key[access] T;
@key[type] T @key[is] @key[array](Integer @key[range] 1..10) @key[of] A;
I : Integer := 3;
@key[function] F(X : Integer := 7) @key[return] A;
Y : A := F(I); --@RI{ Ambiguous?  (We hope so.)}
@end{Example}

@NoPrefix@;Consider the declaration of Y (a complete context).
In the above example, overload resolution can easily determine the
declaration, and therefore the entity,
denoted by Y, A, F, and I.
However, given all of that information,
we still don't know whether F(I) is a @nt{function_call}
or an @nt{indexed_component} whose prefix is a @nt{function_call}.
(In the latter case, it is equivalent to F(7).@key[all](I).)

@NoPrefix@;It seems clear that the declaration of Y ought to be considered
ambiguous.
We describe that by saying that there are two interpretations,
one as a @nt{function_call}, and one as an @nt{indexed_component}.
These interpretations are both acceptable to the overloading
rules.
Therefore, the complete context is ambiguous, and therefore illegal.

@PDefn{Beaujolais effect}
It is the intent that the Ada 9X preference rule for root numeric
operators is more locally enforceable than that of RM83-4.6(15).
It should also eliminate interpretation shifts due to the
addition or removal of a @nt{use_clause}
(the so called @i{Beaujolais} effect).

RM83-8.7 seems to be missing some complete contexts,
such as @nt{pragma_argument_association}s,
@nt{declarative_item}s that are not
declarations or @nt{representation_clause}s,
and @nt{context_item}s.
We have added these, and also replaced the ``must be determinable''
wording of RM83-5.4(3) with the notion that the expression of a
@nt{case_statement} is a complete context.

Cases like the Val attribute are now handled using the normal type
resolution rules, instead of having special cases that explicitly allow
things like ``any integer type.''
@end{DiffWord83}