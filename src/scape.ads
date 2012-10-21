with Ada.Strings.Wide_Wide_Unbounded; use Ada.Strings.Wide_Wide_Unbounded;
with Ada.Strings.Unbounded;           use Ada.Strings.Unbounded;

package Scape
is

   function Decode (Str : String) return Unbounded_Wide_Wide_String;

   function Encode (Str : Unbounded_Wide_Wide_String) return Unbounded_String;

end Scape;
