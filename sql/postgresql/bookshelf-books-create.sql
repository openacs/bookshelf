--
-- The Bookshelf Package
--
-- @author Lars Pind (lars@pinds.com)
-- @creation-date 2002-09-08
--
-- The tables for Bookshelf books
--

create table bookshelf_books (
  book_id                integer not null
                         constraint bookshelf_book_id_fk
                         references acs_objects (object_id)
                         on delete cascade
                         constraint bookshelf_book_pk
                         primary key,
  book_no                integer not null,
  isbn                   varchar(500),
  book_author            text,
  book_title             text not null,
  main_entry             text,
  main_entry_mime_type   varchar(200) default 'text/plain'
                         constraint bkshlf_book_main_mime_type_fk
                         references cr_mime_types;  
  additional_entry       text,
  additional_entry_mime_type 
                         varchar(200) default 'text/plain'
                         constraint book_additional_mime_type_fk
                         references cr_mime_types,
  excerpt                text,
  publish_status         varchar(50) not null
                         constraint bookshelf_book_publish_ck
                         check (publish_status in ('draft', 'publish'))
                         default 'draft',
  read_status            varchar(50) not null
                         constraint bookshelf_book_read_ck
                         check (read_status in ('queue', 'hand', 'shelf'))
                         default 'queue',
  image_width            integer,
  image_height           integer,
  package_id             integer not null
                         constraint bookshelf_book_package_fk
                         references apm_packages (package_id)
                         on delete cascade,
  constraint bookshelf_book_no_un
  unique (package_id, book_no)
);

create view bookshelf_books_published
as
    select *
    from   bookshelf_books
    where  publish_status = 'publish';

create function inline_0 ()
returns integer as '
begin
    perform acs_object_type__create_type(
        ''bookshelf_book'',
        ''Bookshelf Book'',
        ''Bookshelf Books'',
        ''acs_object'',
        ''bookshelf_books'',
        ''book_id'',
        ''bookshelf_book'',
        ''f'',
        null,
        ''bookshelf_book__name''
    );

    return null;
end;' language 'plpgsql';

select inline_0();
drop function inline_0 ();
