@comment{ $Source: e:\\cvsroot/ARM/Source/sp.mss,v $ }
@comment{ $Revision: 1.17 $ $Date: 2000/08/15 01:11:45 $ $Author: Randy $ }
@Part(sysprog, Root="ada.mss")
@Comment{$Date: 2000/08/15 01:11:45 $}

@LabeledNormativeAnnex{Systems Programming}

@begin{Intro}
@Redundant[@Defn{systems programming}
@Defn{low-level programming}
@Defn{real-time systems}
@Defn{embedded systems}
@Defn{distributed systems}
@Defn{information systems}
The Systems Programming Annex specifies additional capabilities
provided for low-level programming. These capabilities are also
required in many real-time, embedded, distributed, and information systems.]
@end{Intro}

@begin{Extend83}
This Annex is new to Ada 95.
@end{Extend83}

@LabeledClause{Access to Machine Operations}

@begin{Intro}
@Redundant[This clause specifies rules regarding access to machine instructions
from within an Ada program.]
@ImplDef{Support for access to machine instructions.}
@end{Intro}

@begin{ImplReq}
@Defn{machine code insertion}
The implementation shall support machine code insertions
(see @RefSecNum{Machine Code Insertions}) or intrinsic subprograms
(see @RefSecNum{Conformance Rules}) (or both).
Implementation-defined attributes shall be provided to
allow the use of Ada entities as operands.
@end{ImplReq}

@begin{ImplAdvice}
The machine code or intrinsics support should allow access to all
operations normally available to assembly language programmers for the
target environment,
including privileged instructions, if any.
@begin{Ramification}
Of course, on a machine with protection, an attempt to execute a
privileged instruction in user mode will probably trap.
Nonetheless, we want implementations to provide access to them so that
Ada can be used to write systems programs that run in privileged mode.
@end{Ramification}

@Defn{interface to assembly language}
@Defn2{Term=[language], Sec=(interface to assembly)}
@Defn{mixed-language programs}
@Defn{assembly language}
The interfacing pragmas (see @RefSecNum{Interface to Other Languages})
should support interface to assembler;
the default assembler should be associated with the convention
identifier Assembler.

If an entity is exported to assembly language, then the implementation
should allocate it at an addressable location,
and should ensure that it is retained by the linking process,
even if not otherwise referenced from the Ada code.
The implementation should assume that any call to a machine code or
assembler subprogram is allowed to read or update every object that is
specified as exported.
@end{ImplAdvice}

@begin{DocReq}

The implementation shall document the overhead associated with calling
machine-code or intrinsic subprograms, as compared to a fully-inlined
call, and to a regular out-of-line call.

The implementation shall document the types of
the package System.Machine_Code usable for machine code
insertions, and the attributes to be used in
machine code insertions for references to Ada entities.

The implementation shall document the subprogram calling conventions
associated with the convention identifiers available for use
with the interfacing pragmas (Ada and Assembler, at a minimum),
including register saving,
exception propagation, parameter passing, and function value returning.

For exported and imported subprograms,
the implementation shall document the mapping
between the Link_Name string, if specified, or
the Ada designator, if not, and the external link name used
for such a subprogram.
@ImplDef{Implementation-defined aspects of access to machine operations.}

@end{DocReq}

@begin{ImplAdvice}

The implementation should ensure that little or no overhead is associated
with calling intrinsic and machine-code subprograms.

@Leading@;It is recommended that intrinsic subprograms be provided for convenient
access to any machine operations that provide special capabilities
or efficiency and that are not otherwise available through the language
constructs. Examples of such instructions
include:
@begin{itemize}

Atomic read-modify-write operations @em e.g., test and set, compare and swap,
decrement and test, enqueue/dequeue.

Standard numeric functions @em e.g., @i{sin}, @i{log}.

String manipulation operations @em e.g., translate and test.

Vector operations @em e.g., compare vector against thresholds.

Direct operations on I/O ports.

@end{itemize}

@end{ImplAdvice}

@LabeledClause{Required Representation Support}

@begin{Intro}
This clause specifies minimal requirements on the
implementation's support for representation items
and related features.
@end{Intro}

@begin{ImplReq}
@PDefn2{Term=[recommended level of support], Sec=(required in Systems
Programming Annex)}
The implementation shall support at least the functionality
defined by the recommended levels of support in Section 13.
@end{ImplReq}

@LabeledClause{Interrupt Support}

@begin{Intro}
@Redundant[This clause specifies the language-defined model for hardware interrupts
in addition to mechanisms for handling interrupts.]
@IndexSee{Term=[signal],See=(interrupt)}
@end{Intro}

@begin{RunTime}

@Defn{interrupt}
@Redundant[An @i{interrupt} represents a class of events that are detected by
the hardware or the system software.]
@Defn2{Term=[occurrence], Sec=(of an interrupt)}
Interrupts are said to occur. An @i{occurrence} of an interrupt is
separable into generation and delivery.
@Defn2{Term=[generation], Sec=(of an interrupt)}
@i{Generation} of an interrupt is the event in the underlying hardware
or system that makes the interrupt available to the program.
@Defn2{Term=[delivery], Sec=(of an interrupt)}
@i{Delivery} is the action that invokes part of the program as
response to the interrupt occurrence.
@Defn{pending interrupt occurrence}
Between generation and delivery, the interrupt occurrence @Redundant[(or
interrupt)] is @i{pending}.
@Defn{blocked interrupt}
Some or all interrupts may be @i{blocked}. When an interrupt is blocked, all
occurrences of that interrupt are prevented from being delivered.
@Defn2{Term=[attaching], Sec=(to an interrupt)}
@Defn{reserved interrupt}
Certain interrupts are @i{reserved}. The set of reserved interrupts is
implementation defined. A reserved interrupt is either an interrupt for
which user-defined handlers are not supported, or one which
already has an attached handler by some other implementation-defined means.
@Defn{interrupt handler}
Program units can be connected to non-reserved interrupts. While
connected, the program unit is said to be @i{attached} to that interrupt.
The execution of that program unit, the @i{interrupt handler}, is invoked upon
delivery of the interrupt occurrence.
@ImplDef{Implementation-defined aspects of interrupts.}
@begin{Honest}
  As an obsolescent feature,
  interrupts may be attached to task entries by an address clause.
  See @RefSecNum{Interrupt Entries}.
@end{Honest}

While a handler is attached to an interrupt, it is called once for each
delivered occurrence of that interrupt. While the handler executes, the
corresponding interrupt is blocked.

While an interrupt is blocked, all occurrences of that interrupt are prevented
from being delivered. Whether such occurrences remain pending or are lost is
implementation defined.

@Defn{default treatment}
Each interrupt has a @i{default treatment} which determines the system's
response to an occurrence of that interrupt when no user-defined
handler is attached. The set of possible default treatments is
implementation defined, as is the method (if one exists) for configuring
the default treatments for interrupts.

An interrupt is delivered to the handler (or default treatment) that is in
effect for that interrupt at the time of delivery.

An exception propagated from a handler that is invoked by an
interrupt has no effect.

@Redundant[If the Ceiling_Locking policy (see @RefSecNum{Priority Ceiling Locking}) is
in effect, the interrupt handler executes with the active priority that is the
ceiling priority of the corresponding protected object.]

@end{RunTime}

@begin{ImplReq}

The implementation shall provide a mechanism to determine the minimum
stack space that is needed
for each interrupt handler and to reserve that space for
the execution of the handler. @Redundant{This space should accommodate
nested invocations of the handler where the system permits this.}

If the hardware or the underlying system holds pending interrupt
occurrences, the implementation shall provide for later delivery
of these occurrences to the program.

If the Ceiling_Locking policy is not in effect, the implementation
shall provide means for the application to specify whether interrupts
are to be blocked during protected actions.

@end{ImplReq}

@begin{DocReq}
@Leading@;The implementation shall document the following items:
@begin{Discussion}
This information may be different for different forms of interrupt handlers.
@end{Discussion}
@begin{Enumerate}
For each interrupt, which interrupts are blocked from delivery when a handler
attached to that interrupt executes (either as a result of an interrupt
delivery or of an ordinary call on a procedure of the corresponding
protected object).

Any interrupts that cannot be blocked, and the effect of attaching
handlers to such interrupts, if this is permitted.

Which run-time stack an interrupt handler uses when it executes as a
result of an interrupt delivery; if this is configurable, what is the
mechanism to do so; how to specify how much space to reserve on that stack.

Any implementation- or hardware-specific activity that happens
before a user-defined interrupt handler gets control (e.g.,
reading device registers, acknowledging devices).

Any timing or other limitations imposed on the execution of interrupt handlers.

The state (blocked/unblocked) of the non-reserved interrupts
when the program starts; if some interrupts are unblocked, what
is the mechanism a program can use to protect itself before it
can attach the corresponding handlers.

Whether the interrupted task is allowed to resume execution before the
interrupt handler returns.

The treatment of interrupt occurrences that are generated while
the interrupt is blocked; i.e., whether one or more occurrences
are held for later delivery, or all are lost.

Whether predefined or implementation-defined exceptions are raised as a
result of the occurrence of any interrupt, and the mapping between the
machine interrupts (or traps) and the predefined
exceptions.

On a multi-processor, the rules governing the delivery of an interrupt
to a particular processor.
@end{Enumerate}
@end{DocReq}

@begin{ImplPerm}

If the underlying system or hardware does not allow interrupts to be
blocked, then no blocking is required @Redundant[as part of the execution of
subprograms of a protected object whose one of its
subprograms is an interrupt handler].

In a multi-processor with more than one interrupt subsystem, it is
implementation defined whether (and how) interrupt sources from
separate subsystems share the same Interrupt_ID type
(see @RefSecNum{The Package Interrupts}).
@begin{discussion}
This issue is tightly related to the issue of scheduling on a
multi-processor. In a sense, if a particular interrupt source is not
available to all processors, the system is not truly homogeneous.

One way to approach this problem is to assign sub-ranges within
Interrupt_ID to each interrupt subsystem, such that @lquotes@;similar@rquotes@; interrupt
sources (e.g. a timer) in different subsystems get a distinct id.
@end{Discussion}
In particular, the meaning of a blocked or pending interrupt may then be
applicable to one processor only.

Implementations are allowed to impose timing or other limitations on the
execution of interrupt handlers.
@begin{Reason}
These limitations are often necessary to ensure proper behavior of the
implementation.
@end{Reason}

Other forms of handlers are allowed to be supported, in which case, the
rules of this subclause should be adhered to.

The active priority of the execution of an interrupt handler is allowed to
vary from one occurrence of the same interrupt to another.

@end{ImplPerm}

@begin{ImplAdvice}

If the Ceiling_Locking policy is not in effect, the implementation
should provide means for the application to specify which interrupts
are to be blocked during protected actions, if the underlying system allows
for a finer-grain control of interrupt blocking.

@end{ImplAdvice}

@begin{Notes}

The default treatment for an interrupt can be to keep the
interrupt pending or to deliver it to an implementation-defined
handler. Examples of actions that an implementation-defined
handler is allowed to perform include aborting the partition, ignoring
(i.e., discarding occurrences of) the interrupt, or queuing one
or more occurrences of the interrupt for possible later delivery
when a user-defined handler is attached to that interrupt.

It is a bounded error to call Task_Identification.Current_Task
(see @RefSecNum{The Package Task_Identification}) from an interrupt handler.

The rule that an exception propagated from an interrupt handler has no effect
is modeled after the rule about exceptions propagated out of task bodies.

@end{Notes}

@LabeledSubClause{Protected Procedure Handlers}

@begin{Syntax}
@begin{SyntaxText}
@Leading@keepnext@;The form of a @nt{pragma} Interrupt_Handler is as follows:
@end{SyntaxText}

@PragmaSyn`@key{pragma} @prag(Interrupt_Handler)(@SynI{handler_}@Syn2{name});'

@begin{SyntaxText}
@Leading@Keepnext@;The form of a @nt{pragma} Attach_Handler is as follows:
@end{SyntaxText}

@PragmaSyn`@key{pragma} @prag(Attach_Handler)(@SynI{handler_}@Syn2{name}, @Syn2{expression});'
@end{Syntax}

@begin{Resolution}

For the Interrupt_Handler and Attach_Handler pragmas, the
@SynI{handler_}@nt{name} shall resolve to denote a protected procedure
with a parameterless profile.

For the Attach_Handler pragma, the expected type for the
@nt{expression} is Interrupts.Interrupt_ID
(see @RefSecNum{The Package Interrupts}).
@end{Resolution}

@begin{Legality}

The Attach_Handler pragma is only allowed immediately within the
@nt{protected_definition}
where the corresponding subprogram is declared.
The corresponding @nt{protected_type_declaration}
or @nt{single_protected_declaration}
shall be a library level declaration.
@begin{Discussion}
In the case of a @nt{protected_type_declaration},
an @nt{object_declaration} of an object of that type
need not be at library level.
@end{Discussion}

The Interrupt_Handler pragma is only allowed immediately within a
@nt{protected_definition}.
The corresponding @nt{protected_type_declaration} shall
be a library level declaration.
In addition, any @nt{object_declaration} of such a type shall be a
library level declaration.
@end{Legality}

@begin{RunTime}

If the pragma Interrupt_Handler appears in a @nt{protected_definition},
then the corresponding procedure can be attached dynamically, as a handler, to
interrupts (see @RefSecNum{The Package Interrupts}).
@Redundant[Such procedures are allowed to be attached to multiple interrupts.]

@Defn2{Term=[creation], Sec=(of a protected object)}
@Defn2{Term=[initialization], Sec=(of a protected object)}
The @nt{expression} in the Attach_Handler pragma @Redundant[as evaluated at
object creation time] specifies an interrupt. As part
of the initialization of that object, if the Attach_Handler pragma is
specified, the @SynI{handler} procedure is attached to the specified interrupt.
@IndexCheck{Reserved_Check}
A check is made that the corresponding interrupt is not reserved.
@Defn2{Term=[Program_Error],Sec=(raised by failure of run-time check)}
Program_Error is raised if the check fails, and the existing treatment
for the interrupt is not affected.

@Defn2{Term=[initialization], Sec=(of a protected object)}
@IndexCheck{Ceiling_Check}
If the Ceiling_Locking policy (see @RefSecNum{Priority Ceiling Locking}) is
in effect then upon the initialization of a protected object that either an
Attach_Handler or Interrupt_Handler pragma applies to one of its procedures,
a check is made that the ceiling priority defined in the
@nt{protected_definition} is in the range of System.Interrupt_Priority.
@Defn2{Term=[Program_Error],Sec=(raised by failure of run-time check)}
If the check fails, Program_Error is raised.

@Defn2{Term=[finalization], Sec=(of a protected object)}
When a protected object is finalized, for any of its procedures that are
attached to interrupts, the handler is detached. If the handler was
attached by a procedure in the Interrupts package or if no user
handler was previously attached to the interrupt, the default treatment is
restored. Otherwise, @Redundant[that is, if an Attach_Handler pragma was
used,] the previous handler is restored.
@begin{Discussion}
Since only library-level protected procedures can be attached as handlers
using the Interrupts package, the finalization discussed above occurs
only as part of the finalization of all library-level packages in a partition.
@end{Discussion}

When a handler is attached to an interrupt, the interrupt is blocked
@Redundant[(subject to the @ImplPermName in @RefSecNum{Interrupt Support})]
during the execution of every protected action on the protected object
containing the handler.

@end{RunTime}

@begin{Erron}

If the Ceiling_Locking policy (see @RefSecNum{Priority Ceiling Locking}) is
in effect and an interrupt is delivered to a handler, and the interrupt
hardware priority is higher than the ceiling priority of the corresponding
protected object, the execution of the program is erroneous.

@end{Erron}

@begin{Metrics}
@Leading@Keepnext@;The following metric shall be documented by the implementation:
@begin{enumerate}
The worst case overhead for an interrupt handler that is a parameterless
protected procedure, in clock cycles. This is the execution time not
directly attributable to the handler procedure or the interrupted execution.
It is estimated as C @en@; (A+B), where A is how long it takes to complete a given
sequence of instructions without any interrupt, B is how long it takes to
complete a normal call to a given protected procedure, and C is how long it
takes to complete the same sequence of instructions when it is interrupted by
one execution of the same procedure called via an interrupt.
@begin{ImplNote}
The instruction sequence and interrupt handler used to measure interrupt
handling overhead should be chosen so as to maximize the execution time cost
due to cache misses. For example, if the processor has cache memory and the
activity of an interrupt handler could invalidate the contents of cache memory, the handler should be written such that it invalidates all of the cache memory.
@end{ImplNote}
@end{enumerate}
@end{Metrics}

@begin{ImplPerm}

When the pragmas Attach_Handler or Interrupt_Handler apply to a protected
procedure, the implementation is allowed to impose
implementation-defined restrictions on the
corresponding @nt{protected_type_declaration} and @nt{protected_body}.
@begin{Ramification}
The restrictions may be on the constructs that are allowed within them,
and on ordinary calls (i.e. not via interrupts) on protected operations in
these protected objects.
@end{Ramification}

An implementation may use a different mechanism for invoking a protected
procedure in response to a hardware interrupt than is used for a call
to that protected procedure from a task.
@begin{Discussion}
This is despite the fact that the priority of an interrupt handler
(see @RefSecNum{Task Priorities}) is modeled after a hardware task calling the
handler.
@end{Discussion}

@Defn{notwithstanding}
Notwithstanding what this subclause says elsewhere,
the Attach_Handler and Interrupt_Handler pragmas are allowed to be used
for other, implementation defined, forms of interrupt handlers.
@begin{Ramification}
For example, if an implementation wishes to allow interrupt
handlers to have parameters, it is allowed to do so via these pragmas;
it need not invent implementation-defined pragmas for the purpose.
@end{Ramification}

@end{ImplPerm}

@begin{ImplAdvice}

Whenever possible, the implementation should allow interrupt handlers to be
called directly by the hardware.

Whenever practical, the implementation should
detect violations of any implementation-defined restrictions
before run time.

@end{ImplAdvice}

@begin{Notes}

The Attach_Handler pragma can provide static attachment of handlers to
interrupts if the implementation supports preelaboration of protected
objects. (See @RefSecNum{Preelaboration Requirements}.)

The ceiling priority of a protected object that one of its procedures is
attached to an interrupt should be at least as high as the highest
processor priority at which that interrupt will ever be delivered.

Protected procedures can also be attached dynamically to interrupts
via operations declared in the predefined package Interrupts.

An example of a possible implementation-defined restriction is
disallowing the use of the standard storage pools within the body of
a protected procedure that is an interrupt handler.

@end{Notes}

@LabeledSubClause{The Package Interrupts}

@begin{StaticSem}

@Leading@Keepnext@;The following language-defined packages exist:
@begin{example}
@ChildUnit{Parent=[Ada],Child=[Interrupts]}
@key{with} System;
@key[package] Ada.Interrupts @key[is]
@LangDefType{Package=[Ada.Interrupts],Type=[Interrupt_ID]}
   @key[type] Interrupt_ID @key[is] @RI{implementation-defined};
@LangDefType{Package=[Ada.Interrupts],Type=[Parameterless_Handler]}
   @key[type] Parameterless_Handler @key[is]
      @key[access] @key[protected] @key[procedure];


   @key[function] @AdaSubDefn{Is_Reserved} (Interrupt : Interrupt_ID)
      @key[return] Boolean;

   @key[function] @AdaSubDefn{Is_Attached} (Interrupt : Interrupt_ID)
      @key[return] Boolean;

   @key[function] @AdaSubDefn{Current_Handler} (Interrupt : Interrupt_ID)
      @key[return] Parameterless_Handler;

   @key[procedure] @AdaSubDefn{Attach_Handler}
      (New_Handler : @key[in] Parameterless_Handler;
       Interrupt   : @key[in] Interrupt_ID);

   @key[procedure] @AdaSubDefn{Exchange_Handler}
      (Old_Handler : @key[out] Parameterless_Handler;
       New_Handler : @key[in] Parameterless_Handler;
       Interrupt   : @key[in] Interrupt_ID);

   @key[procedure] @AdaSubDefn{Detach_Handler}
      (Interrupt : @key[in] Interrupt_ID);

   @key[function] @AdaSubDefn{Reference}(Interrupt : Interrupt_ID)
      @key{return} System.Address;

@key[private]
   ... -- @RI{not specified by the language}
@key[end] Ada.Interrupts;


@ChildUnit{Parent=[Ada.Interrupts],Child=[Names]}
@key[package] Ada.Interrupts.Names @key[is]
   @RI{implementation-defined} : @key[constant] Interrupt_ID :=
     @RI{implementation-defined};
      . . .
   @RI{implementation-defined} : @key[constant] Interrupt_ID :=
     @RI{implementation-defined};
@key[end] Ada.Interrupts.Names;
@end{example}

@end{StaticSem}

@begin{RunTime}

The Interrupt_ID type is an implementation-defined discrete type used to
identify interrupts.

The Is_Reserved function returns True if and only if the specified
interrupt is reserved.

The Is_Attached function returns True if and only if a user-specified
interrupt handler is attached to the interrupt.

The Current_Handler function returns a value that represents the
attached handler of the interrupt. If no user-defined handler is attached to
the interrupt, Current_Handler returns a value that designates the default
treatment; calling Attach_Handler or Exchange_Handler with this value
restores the default treatment.

The Attach_Handler procedure attaches the specified handler to the
interrupt, overriding any existing treatment (including a user handler)
in effect for that interrupt.
If New_Handler is @key[null], the default treatment is restored.
@Defn2{Term=[Program_Error],Sec=(raised by failure of run-time check)}
If New_Handler designates a protected procedure to which the pragma
Interrupt_Handler does not apply, Program_Error is raised. In
this case, the operation does not modify the existing interrupt treatment.

The Exchange_Handler procedure operates in the same manner as Attach_Handler
with the addition that the value returned in Old_Handler designates the
previous treatment for the specified interrupt.
@begin{Ramification}
Calling Attach_Handler or Exchange_Handler with this value for New_Handler
restores the previous handler.
@end{Ramification}

The Detach_Handler procedure restores the default treatment for the
specified interrupt.

For all operations defined in this package that take a parameter of type
Interrupt_ID, with the exception of Is_Reserved and Reference, a check is
made that the specified interrupt is not reserved.
@Defn2{Term=[Program_Error],Sec=(raised by failure of run-time check)}
Program_Error is raised if this check fails.

If, by using the Attach_Handler, Detach_Handler, or Exchange_Handler
procedures, an attempt is made to
detach a handler that was attached statically (using the pragma
Attach_Handler), the handler is not detached and Program_Error is
raised.
@Defn2{Term=[Program_Error],Sec=(raised by failure of run-time check)}

The Reference function returns a value of type System.Address that can
be used to attach a task entry, via an address clause
(see @RefSecNum{Interrupt Entries}) to the interrupt
specified by Interrupt. This function raises Program_Error if attaching
task entries to interrupts (or to this particular interrupt) is not supported.
@Defn2{Term=[Program_Error],Sec=(raised by failure of run-time check)}

@end{RunTime}

@begin{ImplReq}

At no time during attachment or exchange of handlers shall the current handler
of the corresponding interrupt be undefined.

@end{ImplReq}

@begin{DocReq}

If the Ceiling_Locking policy (see @RefSecNum{Priority Ceiling Locking}) is
in effect the implementation shall document the default ceiling priority
assigned to a protected object that contains either the Attach_Handler or
Interrupt_Handler pragmas, but not the Interrupt_Priority pragma.
@Redundant[This default need not be the same for all interrupts.]

@end{DocReq}

@begin{ImplAdvice}

If implementation-defined forms of interrupt handler procedures are supported,
such as protected procedures with parameters, then for each such form of a
handler, a type analogous to Parameterless_Handler should be specified in a
child package of Interrupts, with the same operations as in the
predefined package Interrupts.

@end{ImplAdvice}

@begin{Notes}

The package Interrupts.Names contains implementation-defined
names (and constant values) for the interrupts that are supported by
the implementation.

@end{Notes}

@begin{Examples}
@Leading@Keepnext@i{Example of interrupt handlers:}
@begin{example}
Device_Priority : @key[constant]
  @key[array] (1..5) of System.Interrupt_Priority := ( ... );@Softpage
@key[protected] @key[type] Device_Interface
  (Int_ID : Ada.Interrupts.Interrupt_ID) @key[is]
  @key[procedure] Handler;
  @key[pragma] Attach_Handler(Handler, Int_ID);
  ...
  @key[pragma] Interrupt_Priority(Device_Priority(Int_ID));
@key[end] Device_Interface;@Softpage
  ...
Device_1_Driver : Device_Interface(1);
  ...
Device_5_Driver : Device_Interface(5);
  ...
@end{example}
@end{Examples}

@LabeledClause{Preelaboration Requirements}

@begin{Intro}
@Redundant[This clause specifies additional implementation and documentation
requirements for the Preelaborate pragma (see @RefSecNum{Elaboration Control}).]
@end{Intro}

@begin{ImplReq}

The implementation shall not incur any run-time overhead for the elaboration
checks of subprograms and @nt{protected_bodies} declared in preelaborated
library units.

The implementation shall not execute any memory write operations after
load time for the elaboration of constant objects
declared immediately within the
declarative region of a preelaborated library package, so long as the
subtype and initial expression (or default initial expressions if
initialized by default) of the @nt<object_declaration> satisfy the
following restrictions.
@Defn{load time}
The meaning of @i{load time} is implementation defined.
@begin{Discussion}
On systems where the image of the partition is initially copied from
disk to RAM, or from ROM to RAM, prior to starting execution of the
partition,
the intention is that @lquotes@;load time@rquotes@; consist of this initial copying
step.
On other systems, load time and run time might actually be interspersed.
@end{Discussion}
@begin{itemize}
Any @nt<subtype_mark> denotes a statically constrained subtype, with
statically constrained subcomponents, if any;

any @nt<constraint> is a static constraint;

any @nt<allocator> is for an access-to-constant type;

any uses of predefined operators appear only within static expressions;

any @nt<primari>es that are @nt<name>s, other than @nt<attribute_reference>s
for the Access or Address attributes, appear only within static expressions;
@begin{ramification}
This cuts out @nt<attribute_reference>s that are not static, except for
Access and Address.
@end{Ramification}

any @nt<name> that is not part of a static expression is an expanded
name or @nt<direct_name> that statically denotes some entity;
@begin{Ramification}
This cuts out @nt<function_call>s and @nt<type_conversion>s that are not
static, including calls on attribute functions like 'Image and 'Value.
@end{Ramification}

any @nt<discrete_choice> of an @nt<array_aggregate> is static;

no language-defined check associated with the elaboration of the
@nt<object_declaration> can fail.
@begin{Reason}
The intent is that aggregates all of whose scalar subcomponents are static,
and all of whose access subcomponents are @key(null), allocators for
access-to-constant types, or X'Access, will be supported with no run-time
code generated.
@end{Reason}
@end{itemize}

@end{ImplReq}

@begin{DocReq}

The implementation shall document any circumstances under which the
elaboration of a preelaborated package causes code to be executed at run time.

The implementation shall document whether the method used for initialization
of preelaborated variables allows a partition to be restarted without
reloading.
@ImplDef{Implementation-defined aspects of preelaboration.}
@begin{discussion}
This covers the issue of the RTS itself being restartable,
so that need not be a separate @DocReqName.
@end{discussion}

@end{DocReq}

@begin{ImplAdvice}

It is recommended that preelaborated packages be implemented in such a
way that there should be little or no code executed at run time for the
elaboration of entities not already covered by the @ImplReqName@;s.

@end{ImplAdvice}

@LabeledClause{Pragma Discard_Names}

@begin{Intro}
@Redundant[A @nt{pragma} Discard_Names may be used to request a
reduction in storage used for the names of certain entities.]
@end{Intro}

@begin{Syntax}
@begin{SyntaxText}
@Leading@Keepnext@;The form of a @nt{pragma} Discard_Names is as follows:
@end{SyntaxText}

@PragmaSyn`@key{pragma} @prag(Discard_Names)[([On => ] @Syn2[local_name])];'

@begin{SyntaxText}
A @nt{pragma} Discard_Names is allowed only immediately within a
@nt{declarative_part}, immediately within a @nt{package_specification},
or as a configuration pragma.
@end{SyntaxText}
@end{Syntax}

@begin{Legality}
The @nt{local_name} (if present) shall denote a non-derived
enumeration @Redundant[first] subtype,
a tagged @Redundant[first] subtype, or an exception.
The pragma applies to the type or exception.
Without a @nt{local_name}, the pragma applies to all such entities
declared after the pragma, within the same declarative region.
Alternatively, the pragma can be used as a configuration pragma.
If the pragma applies to a type,
then it applies also to all descendants of the type.
@end{Legality}

@begin{StaticSem}
@PDefn2{Term=[representation pragma], Sec=(Discard_Names)}
@PDefn2{Term=[pragma, representation], Sec=(Discard_Names)}
If a @nt{local_name} is given, then
a @nt{pragma} Discard_Names is a representation pragma.


If the pragma applies to an enumeration type,
then the semantics of the Wide_Image and Wide_Value attributes
are implementation defined for that type;
@Redundant[the semantics of Image and Value are still defined in terms
of Wide_Image and Wide_Value.]
In addition, the semantics of Text_IO.Enumeration_IO are implementation
defined.
If the pragma applies to a tagged type,
then the semantics of the Tags.Expanded_Name function
are implementation defined for that type.
If the pragma applies to an exception,
then the semantics of the Exceptions.Exception_Name function
are implementation defined for that exception.

@ImplDef{The semantics of pragma Discard_Names.}
@begin{Ramification}
  The Width attribute is still defined in terms of Image.

  The semantics of S'Wide_Image and S'Wide_Value are
  implementation defined for any subtype of an enumeration type to which
  the pragma applies. (The pragma actually names the first subtype,
  of course.)
@end{Ramification}
@end{StaticSem}

@begin{ImplAdvice}
If the pragma applies to an entity, then the implementation should
reduce the amount of storage used for storing names associated with that
entity.
@begin{Reason}
A typical implementation of the Image attribute for enumeration types is
to store a table containing the names of all the enumeration literals.
Pragma Discard_Names allows the implementation to avoid storing such a
table without having to prove that the Image attribute is never used
(which can be difficult in the presence of separate compilation).

We did not specify the semantics of the Image attribute in the presence
of this pragma because different semantics might be desirable in
different situations.
In some cases, it might make sense to use the Image attribute to print
out a useful value that can be used to identify the entity given
information in compiler-generated listings.
In other cases, it might make sense to get an error at compile time or
at run time.
In cases where memory is plentiful, the simplest implementation makes
sense: ignore the pragma.
Implementations that are capable of avoiding the extra storage in cases
where the Image attribute is never used might also wish to ignore the
pragma.

The same applies to the Tags.Expanded_Name and Exceptions.Exception_Name
functions.
@end{Reason}
@end{ImplAdvice}

@LabeledClause{Shared Variable Control}

@begin{Intro}
@Redundant[This clause specifies representation pragmas that control the use of
shared variables.]
@end{Intro}

@begin{Syntax}
@begin{SyntaxText}
@Leading@;The form for pragmas Atomic, Volatile, Atomic_Components, and
Volatile_Components is as follows:
@end{SyntaxText}

@PragmaSyn`@key{pragma} @prag(Atomic)(@Syn2{local_name});'

@PragmaSyn`@key{pragma} @prag(Volatile)(@Syn2{local_name});'

@PragmaSyn`@key{pragma} @prag(Atomic_Components)(@SynI{array_}@Syn2{local_name});'

@PragmaSyn`@key{pragma} @prag(Volatile_Components)(@SynI{array_}@Syn2{local_name});'

@end{Syntax}

@begin{Intro}
@Defn{atomic}
An @i{atomic} type is one to which a pragma Atomic applies.
An @i{atomic} object (including a component)
is one to which a
pragma Atomic applies, or a component of an array to which
a pragma Atomic_Components applies, or any object of an atomic type.

@Defn{volatile}
A @i{volatile} type is one to which a pragma Volatile applies.
A @i{volatile} object (including a component)
is one to which a pragma Volatile applies,
or a component of an array to which a pragma Volatile_Components applies,
or any object of a volatile type.
In addition, every atomic type or object is also defined to be volatile.
Finally, if an object is volatile, then so
are all of its subcomponents @Redundant[(the same does not apply to atomic)].
@end{Intro}

@begin{Resolution}

The @nt{local_name} in an Atomic or Volatile pragma shall resolve to denote
either an @nt{object_declaration}, a non-inherited @nt{component_declaration},
or a @nt{full_type_declaration}. The
@SynI{array_}@nt{local_name} in an Atomic_Components or
Volatile_Components pragma shall resolve to denote the declaration
of an array type or an array object of an anonymous type.

@end{Resolution}

@begin{Legality}
@Defn{indivisible}
It is illegal to apply either an Atomic or Atomic_Components pragma to an
object or type if the implementation cannot support the indivisible reads
and updates required by the pragma (see below).

It is illegal to specify the Size attribute of an atomic object,
the Component_Size attribute for an array type with atomic
components, or the layout attributes of an atomic component,
in a way that prevents the implementation from performing the
required indivisible reads and updates.

If an atomic object is passed as a parameter, then the type of the formal
parameter shall either be atomic or allow pass by copy @Redundant[(that
is, not be a nonatomic by-reference type)]. If an atomic object is used
as an actual for a generic formal object of mode @key{in out}, then the
type of the generic formal object shall be atomic. If the @nt<prefix> of
an @nt<attribute_reference> for an Access attribute denotes an atomic
object @Redundant[(including a component)], then the designated type of
the resulting access type shall be atomic. If an atomic type is used as
an actual for a generic formal derived type, then the ancestor of the
formal type shall be atomic or allow pass by copy. Corresponding rules
apply to volatile objects and types.

If a pragma Volatile, Volatile_Components, Atomic, or Atomic_Components
applies to a stand-alone constant object, then a pragma Import shall
also apply to it.
@begin{Ramification}
Hence, no initialization expression is allowed for such a constant. Note
that a constant that is atomic or volatile because of its type is allowed.
@end{Ramification}
@begin{Reason}
Stand-alone constants that are explicitly specified as Atomic or Volatile
only make sense if they are being manipulated outside the Ada program.
From the Ada perspective the object is read-only. Nevertheless, if
imported and atomic or volatile, the implementation should presume it
might be altered externally.
For an imported stand-alone constant that is not atomic or
volatile, the implementation can assume that it will not be
altered.
@end{Reason}

@end{Legality}

@begin{StaticSem}

@PDefn2{Term=[representation pragma], Sec=(Atomic)}
@PDefn2{Term=[pragma, representation], Sec=(Atomic)}
@PDefn2{Term=[representation pragma], Sec=(Volatile)}
@PDefn2{Term=[pragma, representation], Sec=(Volatile)}
@PDefn2{Term=[representation pragma], Sec=(Atomic_Components)}
@PDefn2{Term=[pragma, representation], Sec=(Atomic_Components)}
@PDefn2{Term=[representation pragma], Sec=(Volatile_Components)}
@PDefn2{Term=[pragma, representation], Sec=(Volatile_Components)}
These @nt{pragma}s are representation pragmas
(see @RefSecNum{Representation Items}).

@end{StaticSem}

@begin{RunTime}

For an atomic object (including an atomic component) all reads and
updates of the object as a whole are indivisible.

For a volatile object all reads and updates of the
object as a whole are performed directly to memory.
@begin{ImplNote}
This precludes any use of register temporaries, caches, and other
similar optimizations for that object.
@end{ImplNote}

@Defn2{Term=[sequential], Sec=(actions)}
Two actions are sequential (see @RefSecNum{Shared Variables}) if each
is the read or update of the same atomic object.

@PDefn2{Term=[by-reference type], Sec=(atomic or volatile)}
If a type is atomic or volatile and it is not a by-copy type, then the type
is defined to be a by-reference type. If any subcomponent of a type is
atomic or volatile, then the type is defined to be a by-reference type.

If an actual parameter is atomic or volatile, and the corresponding
formal parameter is not, then the parameter is passed by copy.
@begin{ImplNote}
Note that in the case where such a parameter is normally passed by
reference, a copy of the actual will have to be produced at the call-site,
and a pointer to the copy passed to the formal parameter. If the actual
is atomic, any copying has to use indivisible read on the way in, and
indivisible write on the way out.
@end{ImplNote}
@begin{Reason}
It has to be known at compile time whether an atomic or a volatile parameter
is to be passed by copy or by reference. For some types, it is unspecified
whether parameters are passed by copy or by reference. The above rules
further specify the parameter passing rules involving atomic and volatile
types and objects.
@end{Reason}

@end{RunTime}

@begin{ImplReq}

@PDefn2{Term=[external effect], Sec=(volatile/atomic objects)}
The external effect of a program
(see @RefSecNum(Conformity of an Implementation with the Standard))
is defined to include each read and update
of a volatile or atomic object. The implementation shall not
generate any memory reads or updates of atomic or volatile
objects other than those specified by the program.
@begin{Discussion}
The presumption is that volatile or atomic objects might reside in an
@lquotes@;active@rquotes@; part of the address space where each read has a potential
side-effect, and at the very least might deliver a different value.

@Leading@;The rule above and the definition of external effect are intended to
prevent (at least) the following incorrect optimizations, where V is
a volatile variable:
@begin{itemize}
X:= V; Y:=V; cannot be allowed to be translated as Y:=V; X:=V;

Deleting redundant loads: X:= V; X:= V; shall read the value of V from
memory twice.

Deleting redundant stores: V:= X; V:= X; shall write into V twice.

Extra stores: V:= X+Y; should not translate to something like V:= X; V:= V+Y;

Extra loads: X:= V; Y:= X+Z; X:=X+B; should not translate to something like
Y:= V+Z; X:= V+B;

Reordering of loads from volatile variables: X:= V1; Y:= V2; (whether or not
V1 = V2) should not translate to Y:= V2; X:= V1;

Reordering of stores to volatile variables: V1:= X; V2:= X; should not
translate to V2:=X; V1:= X;
@end{itemize}
@end{Discussion}

If a pragma Pack applies to a type any of whose subcomponents are atomic,
the implementation shall not pack the atomic subcomponents more tightly
than that for which it can support indivisible reads and updates.
@begin{ImplNote}
A warning might be appropriate if no packing whatsoever can be achieved.
@end{ImplNote}

@end{ImplReq}

@begin{Notes}

An imported volatile or atomic constant behaves as a constant (i.e.
read-only) with respect to other parts of the Ada program, but can
still be modified by an @lquotes@;external source.@rquotes@;

@end{Notes}

@begin{Incompatible83}
Pragma Atomic replaces Ada 83's pragma Shared.
The name @lquotes@;Shared@rquotes@; was confusing,
because the pragma was not used to mark variables as shared.
@end{Incompatible83}

@LabeledClause{Task Identification and Attributes}

@begin{Intro}
@Redundant[This clause describes operations and attributes that can be
used to obtain the identity of a task. In addition,
a package that associates user-defined information with a task is
defined.]
@end{Intro}

@LabeledSubClause{The Package Task_Identification}

@begin{StaticSem}
@Leading@Keepnext@;The following language-defined library package exists:
@begin{example}
@ChildUnit{Parent=[Ada],Child=[Task_Identification]}
@key[package] Ada.Task_Identification @key[is]
@LangDefType{Package=[Ada.Task_Identification],Type=[Task_ID]}
   @key[type] Task_ID @key[is] @key{private};
   @AdaSubDefn{Null_Task_ID} : @key{constant} Task_ID;
   @key{function}  "=" (Left, Right : Task_ID) @key{return} Boolean;

   @key{function}  @AdaSubDefn{Image}        (T : Task_ID) @key{return} String;
   @key[function]  @AdaSubDefn{Current_Task} @key[return] Task_ID;
   @Key[procedure] @AdaSubDefn{Abort_Task}   (T : @key[in] @key[out] Task_ID);

   @key[function]  @AdaSubDefn{Is_Terminated}(T : Task_ID) @key{return} Boolean;
   @key[function]  @AdaSubDefn{Is_Callable}  (T : Task_ID) @key{return} Boolean;
@key[private]
   ... -- @RI{not specified by the language}
@key[end] Ada.Task_Identification;
@end{example}
@end{StaticSem}

@begin{RunTime}

A value of the type Task_ID identifies an existent task. The constant
Null_Task_ID does not identify any task. Each object of the type Task_ID
is default initialized to the value of Null_Task_ID.

The function "=" returns True if and only if Left and Right identify the same
task or both have the value Null_Task_ID.

The function Image returns an implementation-defined string that identifies
T. If T equals Null_Task_ID, Image returns an empty string.
@ImplDef{The result of the Task_Identification.Image attribute.}

The function Current_Task returns a value that identifies the calling task.

The effect of Abort_Task is the same as the @nt{abort_statement} for the
task identified by T. @Redundant[In addition, if T identifies the
environment task, the entire partition is aborted, See @RefSecNum{Partitions}.]

The functions Is_Terminated and Is_Callable return the value of the
corresponding attribute of the task identified by T.

@Leading@;For @PrefixType{a @nt<prefix> T that is of a task type
@Redundant[(after any implicit dereference)]},
the following attribute is defined:
@begin{Description}

@Attribute{Prefix=<T>, AttrName=<Identity>,
  Text=[Yields a value of the type Task_ID that identifies
    the task denoted by T.]}

@end{Description}
@EndPrefixType{}

@Leading@;For @PrefixType{a @nt<prefix> E that denotes an
@nt<entry_declaration>},
the following attribute is defined:
@begin{Description}
@Attribute{Prefix=<E>, AttrName=<Caller>,
    Text=[Yields a value of the type Task_ID that identifies the task
       whose call is now being serviced. Use of this attribute is
       allowed only inside an @nt{entry_body} or @nt{accept_statement}
       corresponding to the @nt{entry_declaration} denoted by E.]}
@end{Description}
@EndPrefixType{}

@Defn2{Term=[Program_Error],Sec=(raised by failure of run-time check)}
Program_Error is raised if a value of Null_Task_ID is passed
as a parameter to Abort_Task, Is_Terminated, and Is_Callable.

@PDefn2{Term=[potentially blocking operation],Sec=(Abort_Task)}
@PDefn2{Term=[blocking, potentially],Sec=(Abort_Task)}
Abort_Task is a potentially blocking operation
(see @RefSecNum{Protected Subprograms and Protected Actions}).
@end{RunTime}

@begin{Bounded}

It is a bounded error to call the Current_Task function from
an entry body or an interrupt handler.
@Defn2{Term=[Program_Error],Sec=(raised by failure of run-time check)}
Program_Error is raised, or an implementation-defined value of the type
Task_ID is returned.
@ImplDef{The value of Current_Task when in a protected entry or
interrupt handler.}
@begin{ImplNote}
This value could be Null_Task_ID, or the ID of some user task, or that of
an internal task created by the implementation.
@end{ImplNote}

@end{Bounded}

@begin{Erron}

If a value of Task_ID is passed as a parameter to any of the operations
declared in this package (or any language-defined child of this
package), and the corresponding task object no longer exists,
the execution of the program is erroneous.

@end{Erron}

@begin{DocReq}

The implementation shall document the effect of calling Current_Task
from an entry body or interrupt handler.
@ImplDef{The effect of calling Current_Task from an
entry body or interrupt handler.}
@end{DocReq}

@begin{Notes}

This package is intended for use in writing user-defined task scheduling
packages and constructing server tasks. Current_Task can be used in
conjunction with other operations requiring a task as an argument such
as Set_Priority (see @RefSecNum{Dynamic Priorities}).

The function Current_Task and the attribute Caller can return a
Task_ID value that identifies the environment task.

@end{Notes}

@LabeledSubClause{The Package Task_Attributes}

@begin{StaticSem}
@Leading@Keepnext@;The following language-defined generic library package exists:
@begin{example}
@key{with} Ada.Task_Identification; @key{use} Ada.Task_Identification;
@key{generic}
   @key{type} Attribute @key{is} @key{private};
   Initial_Value : @key[in] Attribute;
@ChildUnit{Parent=[Ada],Child=[Task_Attributes]}
@key{package} Ada.Task_Attributes @key{is}

@LangDefType{Package=[Ada.Task_Attributes],Type=[Attribute_Handle]}
   @key{type} Attribute_Handle @key{is} @key{access} @key{all} Attribute;

   @key{function} @AdaSubDefn{Value}(T : Task_ID := Current_Task)
     @key{return} Attribute;

   @key{function} @AdaSubDefn{Reference}(T : Task_ID := Current_Task)
     @key{return} Attribute_Handle;

   @key{procedure} @AdaSubDefn{Set_Value}(Val : @key[in] Attribute;
                             T : @key[in] Task_ID := Current_Task);
   @key{procedure} @AdaSubDefn{Reinitialize}(T : @key[in] Task_ID := Current_Task);

@key{end} Ada.Task_Attributes;
@end{example}

@end{StaticSem}

@begin{RunTime}

When an instance of Task_Attributes is elaborated in
a given active partition, an object of the
actual type corresponding to the formal type Attribute
is implicitly created for each task (of that partition)
that exists and is not yet terminated.
This object acts as a user-defined attribute of the task.
A task created previously
in the partition and not yet terminated has this attribute
from that point on. Each task subsequently created in the partition
will have this attribute when created. In all these cases, the initial value
of the given attribute is Initial_Value.

The Value operation returns the value of the corresponding attribute of T.

The Reference operation returns an access value that designates the
corresponding attribute of T.

The Set_Value operation performs any finalization on the old value of the
attribute of T and assigns Val to that attribute
(see @RefSecNum{Assignment Statements} and
@RefSecNum{User-Defined Assignment and Finalization}).

The effect of the Reinitialize operation is the same as Set_Value where
the Val parameter is replaced with Initial_Value.
@begin{ImplNote}
In most cases, the attribute memory can be reclaimed at this point.
@end{ImplNote}

@Defn2{Term=[Tasking_Error],Sec=(raised by failure of run-time check)}
For all the operations declared in this package, Tasking_Error is raised
if the task identified by T is terminated.
@Defn2{Term=[Program_Error],Sec=(raised by failure of run-time check)}
Program_Error is raised if the value of T is Null_Task_ID.

@end{RunTime}

@begin{Erron}
It is erroneous to dereference the access value returned by a given
call on Reference after a subsequent call on Reinitialize for
the same task attribute, or after the associated task terminates.
@begin{Reason}
  This allows the storage to be reclaimed for the object
  associated with an attribute upon Reinitialize or task termination.
@end{Reason}

If a value of Task_ID is passed as a parameter to any of the operations
declared in this package and the corresponding task object no longer exists,
the execution of the program is erroneous.
@end{Erron}

@begin{ImplReq}
The implementation shall perform each of the above operations for
a given attribute of a given task atomically with respect
to any other of the above operations for the same attribute of the same task.
@begin{Ramification}
Hence, other than by dereferencing an access value returned by
Reference, an attribute of a given task can be safely read and updated
concurrently by multiple tasks.
@end{Ramification}

When a task terminates, the implementation shall finalize
all attributes of the task, and reclaim any other storage
associated with the attributes.
@end{ImplReq}

@begin{DocReq}

The implementation shall document the limit on the number of attributes
per task, if any, and the limit on the total storage for attribute values
per task, if such a limit exists.

In addition, if these limits can be configured, the implementation shall
document how to configure them.
@ImplDef{Implementation-defined aspects of Task_Attributes.}

@end{DocReq}

@begin{Metrics}

The implementation shall document the following metrics: A task calling the
following subprograms shall execute in a sufficiently high priority as to not
be preempted during the measurement period. This period shall start just
before issuing the call and end just after the call completes. If the
attributes of task T are accessed by the measurement tests, no other task
shall access attributes of that task during the measurement period.
For all measurements described here, the Attribute type shall be a scalar
whose size is equal to the size of the predefined
integer size.
For each measurement, two cases shall be documented: one
where the accessed attributes are of the calling task @Redundant[(that is,
the default value for the T parameter is used)], and the other, where T
identifies another, non-terminated, task.

@Leading@;The following calls (to subprograms in the Task_Attributes package)
shall be measured:
@begin{Itemize}
a call to Value, where the return value is Initial_Value;

a call to Value, where the return value is not equal to Initial_Value;

a call to Reference, where the return value designates a value equal to
Initial_Value;

a call to Reference, where the return value designates a value not equal
to Initial_Value;

a call to Set_Value where the Val parameter is not equal to Initial_Value
and the old attribute value is equal to Initial_Value.

a call to Set_Value where the Val parameter is not equal to Initial_Value
and the old attribute value is not equal to Initial_Value.

@end{Itemize}
@end{Metrics}

@begin{ImplPerm}

An implementation need not actually create the object corresponding
to a task attribute
until its value is set to something other than that of Initial_Value,
or until Reference is called for the task attribute.
Similarly, when the value of the attribute is
to be reinitialized to that of Initial_Value,
the object may instead be finalized and its storage reclaimed, to
be recreated when needed later.
While the object does not exist, the function Value may
simply return Initial_Value, rather than implicitly creating the object.
@begin{Discussion}
The effect of this permission can only be observed if the assignment
operation for the corresponding type has side-effects.
@end{Discussion}
@begin{ImplNote}
This permission means that even though every task has every
attribute, storage need only be allocated for those attributes
that have been Reference'd or set to a value other than that
of Initial_Value.
@end{ImplNote}

An implementation is allowed to place restrictions on the maximum number of
attributes a task may have, the maximum size of each attribute, and the
total storage size allocated for all the attributes of a task.

@end{ImplPerm}

@begin{ImplAdvice}

Some implementations are targeted to domains in which memory use at run
time must be completely deterministic. For such implementations, it is
recommended that the storage for task attributes will be pre-allocated
statically and not from the heap. This can be accomplished by either
placing restrictions on the number and the size of the task's attributes,
or by using the pre-allocated storage for the first N attribute objects,
and the heap for the others. In the latter case, N should be documented.

@end{ImplAdvice}

@begin{Notes}

An attribute always exists (after instantiation), and has the initial value.
It need not occupy memory until the first operation that potentially
changes the attribute value. The same holds true after Reinitialize.

The result of the Reference function should be used with care; it is always
safe to use that result in the task body whose attribute is being
accessed. However, when the result is being used by another task, the
programmer must make sure that the task whose attribute is being accessed
is not yet terminated. Failing to do so could make the program execution
erroneous.

As specified in @RefSecNum{The Package Task_Identification}, if the parameter
T (in a call on a subprogram of an instance of this package) identifies
a nonexistent task, the execution of the program is erroneous.

@end{Notes}