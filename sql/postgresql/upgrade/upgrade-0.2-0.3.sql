--
-- Upgrade to add mime_type for main_entry and additional_entry
--
-- @author Lars Pind (lars@pinds.com)
-- @creation-date 2004-05-20
--

alter table bookshelf_books add main_entry_mime_type varchar(200) 
                  constraint bkshlf_book_main_mime_type_fk
                  references cr_mime_types;

alter table bookshelf_books alter column main_entry_mime_type set default 'text/plain';

update bookshelf_books set main_entry_mime_type = 'text/plain';

alter table bookshelf_books add additional_entry_mime_type varchar(200)
                  constraint book_additional_mime_type_fk
                  references cr_mime_types;

alter table bookshelf_books alter column additional_entry_mime_type set default 'text/plain';

update bookshelf_books set additional_entry_mime_type = 'text/plain';


delete from acs_function_args where function = 'BOOKSHELF_BOOK__NEW';

select define_function_args ('bookshelf_book__new', 'book_id,object_type;bookshelf_book,package_id,isbn,book_author,book_title,main_entry,main_entry_mime_type,additional_entry,additional_entry_mime_type,excerpt,publish_status,read_status,creation_date,creation_user,creation_ip');

-- Note, that we create this function in addition to the existing one, 
-- so we don't break other packages which might depend on this

create or replace function bookshelf_book__new (
  integer, -- book_id
  varchar, -- object_type
  integer, -- package_id
  varchar, -- isbn
  text,    -- book_author
  text,    -- book_title
  text,    -- main_entry
  text,    -- main_entry_mime_type
  text,    -- additional_entry
  text,    -- additional_entry_mime_type
  text,    -- excerpt
  varchar, -- publish_status
  varchar, -- read_status
  date,    -- creation_date
  integer, -- creation_user
  varchar  -- creation_ip       
)
returns integer as '
declare
    p_book_id                       alias for $1;
    p_object_type                   alias for $2;
    p_package_id                    alias for $3;
    p_isbn                          alias for $4;
    p_book_author                   alias for $5;
    p_book_title                    alias for $6;
    p_main_entry                    alias for $7;
    p_main_entry_mime_type          alias for $8;
    p_additional_entry              alias for $9;
    p_additional_entry_mime_type    alias for $10;
    p_excerpt                       alias for $11;
    p_publish_status                alias for $12;
    p_read_status                   alias for $13;
    p_creation_date                 alias for $14;
    p_creation_user                 alias for $15;
    p_creation_ip                   alias for $16;
    v_book_id                       integer;
    v_book_no                       integer;
    v_creation_date                 date;
begin
    if p_creation_date is null then
        v_creation_date := now();
    else
        v_creation_date := p_creation_date;
    end if;

    v_book_id := acs_object__new(
        p_book_id,
        p_object_type,
        v_creation_date,
        p_creation_user,
        p_creation_ip,
        p_package_id
    );

    select coalesce(max(book_no),0) + 1
    into   v_book_no
    from   bookshelf_books
    where  package_id = p_package_id;

    insert into bookshelf_books
    (book_id, book_no, isbn, book_author, book_title, main_entry, main_entry_mime_type, additional_entry, 
     additional_entry_mime_type, excerpt, publish_status, read_status, package_id)
    values
    (v_book_id, v_book_no, p_isbn, p_book_author, p_book_title, p_main_entry, p_main_entry_mime_type, p_additional_entry, 
     p_additional_entry_mime_type, p_excerpt, p_publish_status, p_read_status, p_package_id);

    return v_book_id;
end;
' language 'plpgsql';

