--
-- The Bookshelf Package
--
-- @author Lars Pind (lars@pinds.com)
-- @creation-date 2002-09-08
--
-- Dropping the tables for Bookshelf books
--

drop view bookshelf_books_published;
drop table bookshelf_books;
delete from acs_objects where object_type = 'bookshelf_book';

create function inline_0 ()
returns integer as '
begin
    perform acs_object_type__drop_type (
        ''bookshelf_book'', ''f''
    );

    return null;
end;' language 'plpgsql';

select inline_0();
drop function inline_0 ();
