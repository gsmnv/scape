with Ada.Characters.Conversions; use Ada.Characters.Conversions;
with Ada.Containers.Ordered_Maps;

package body Scape
is

   package Ordered_Map is new Ada.Containers.Ordered_Maps
     (Key_Type     => Unbounded_String,
      Element_Type => Wide_Wide_Character,
      "<"          => "<",
      "="          => "=");
   use Ordered_Map;


   Escape_List : Map;

   function Entity_Complete (Entity : Unbounded_String) return Boolean is
      (Element (Entity, 1) = '&' and Element (Entity, Length (Entity)) = ';');

   function Decode (Str : String) return Unbounded_Wide_Wide_String
   is
      Entity : Unbounded_String;
      Start  : Boolean := False;
      Result : Unbounded_Wide_Wide_String;
   begin
      for I in Str'Range loop

         if Str (I) = '&' then
            Start := True;
         end if;

         if not Start then
            Result := Result & To_Wide_Wide_Character (Str (I));
         end if;

         if Start then
            Entity := Entity & Str (I);
         end if;

         if Length (Entity) > 2 then
            if Entity_Complete (Entity) then
               declare
                  C : constant Cursor := Find (Escape_List, Entity);
               begin
                  if not (C = No_Element) then
                     Result := Result & Element (C);
                  end if;
               end;
            end if;
         end if;

         if Str (I) = ';' then
            Start := False;
            Delete (Entity, 1, Length (Entity));
         end if;
      end loop;
      return Result;
   end Decode;

   function Search (E : Wide_Wide_Character) return Cursor
   is
   begin
      for C in Iterate (Escape_List) loop
         if Element (C) = E then
            return C;
         end if;
      end loop;
      return No_Element;
   end Search;

   function Encode (Str : Unbounded_Wide_Wide_String) return Unbounded_String
   is
      Result : Unbounded_String;
      C      : Cursor;
   begin
      for I in 1 .. Length (Str) loop
         C := Search (Element (Str, I));
         if not (C = No_Element) then
            Result := Result & Key (C);
         else
            Result := Result & To_String (Element (Str, I) & "");
         end if;
      end loop;
      return Result;
   end Encode;

begin
   pragma Wide_Character_Encoding ('8');
   -- Add more by yourself.
   Insert (Escape_List, To_Unbounded_String ("&euro;" ), '€');
   Insert (Escape_List, To_Unbounded_String ("&nbsp;" ), ' ');
   Insert (Escape_List, To_Unbounded_String ("&quot;" ), '"');
   Insert (Escape_List, To_Unbounded_String ("&amp;"  ), '&');
   Insert (Escape_List, To_Unbounded_String ("&lt;"   ), '<');
   Insert (Escape_List, To_Unbounded_String ("&gt;"   ), '>');
   Insert (Escape_List, To_Unbounded_String ("&mdash;"), '—');
end Scape;
