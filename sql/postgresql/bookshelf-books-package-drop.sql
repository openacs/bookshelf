--
-- The Bookshelf Package
--
-- @author Lars Pind (lars@pinds.com)
-- @creation-date 2002-09-08
--
-- Dropping the Package for Bookshelf books
--

drop function bookshelf_book__new(
  integer, -- book_id
  varchar, -- object_type
  integer, -- package_id
  varchar, -- isbn
  text,    -- book_title
  text,    -- book_author
  text,    -- main_entry
  text,    -- additional_entry
  text,    -- excerpt
  varchar, -- publish_status
  varchar, -- read_status
  date,    -- creation_date
  integer, -- creation_user
  varchar, -- creation_ip       
  integer  -- context_id
);

drop function bookshelf_book__delete (integer);

drop function bookshelf_book__name (integer);

drop function bookshelf_book__read_status_sort_order (varchar);

drop function bookshelf_book__read_status_pretty (varchar);

drop function bookshelf_book__pub_status_sort_order(varchar);

drop function bookshelf_book__pub_status_pretty(varchar);
