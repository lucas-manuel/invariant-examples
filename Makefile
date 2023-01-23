bounded-invariant:
	FOUNDRY_PROFILE=no_revert forge t --mc BoundedInvariants

unbounded-invariant:
	FOUNDRY_PROFILE=allow_revert forge t --mc UnboundedInvariants

open-invariant:
	FOUNDRY_PROFILE=allow_revert forge t --mc OpenInvariants
