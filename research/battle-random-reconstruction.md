# Red BattleRandom reconstruction

All seven verified Red releases contain one complete 56-byte `BattleRandom` in bank `$0f`. Outside link battle state `$04`, it tail-jumps to the release's verified `Random`. In link battles it consumes a shared ten-byte list; after the last selectable entry it resets the index and updates nine seeds with `seed = (seed * 5 + 1) mod 256`.

Japanese rev0/rev1 use `$718d`/`$7192`, `wLinkState=$d0f0`, index `$ccde`, and list `$d10d`. English uses `$6e9b`, link state `$d12b`, and list `$d148`; other European builds use link state `$d130`, list `$d14d`, and release-specific entry addresses. The list index remains `$ccde` in every release.

The source basis is `pret/pokered@af519899719f0754965776faac0e836a3b906e6d`, `engine/battle/core.asm`. Reports publish structure and hashes, never ROM bytes.
