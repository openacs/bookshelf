--
-- The Bookshelf Package
--
-- @author Lars Pind (lars@pinds.com)
-- @creation-date 2002-09-08
--
-- The Package for Bookshelf books
--

select define_function_args ('bookshelf_book__new', 'book_id,object_type;bookshelf_book,package_id,isbn,book_author,book_title,main_entry,additional_entry,excerpt,publish_status,read_status,creation_date,creation_user,creation_ip,context_id');

create function bookshelf_book__new (
  integer, -- book_id
  varchar, -- object_type
  integer, -- package_id
  varchar, -- isbn
  text,    -- book_author
  text,    -- book_title
  text,    -- main_entry
  text,    -- additional_entry
  text,    -- excerpt
  varchar, -- publish_status
  varchar, -- read_status
  date,    -- creation_date
  integer, -- creation_user
  varchar, -- creation_ip       
  integer  -- context_id
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
    p_additional_entry              alias for $8;
    p_excerpt                       alias for $9;
    p_publish_status                alias for $10;
    p_read_status                   alias for $11;
    p_creation_date                 alias for $12;
    p_creation_user                 alias for $13;
    p_creation_ip                   alias for $14;
    p_context_id                    alias for $15;
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
        coalesce(p_context_id, p_package_id)
    );

    select coalesce(max(book_no),0) + 1
    into   v_book_no
    from   bookshelf_books
    where  package_id = p_package_id;

    insert into bookshelf_books
    (book_id, book_no, isbn, book_author, book_title, main_entry, additional_entry, excerpt, 
     publish_status, read_status, package_id)
    values
    (v_book_id, v_book_no, p_isbn, p_book_author, p_book_title, p_main_entry, p_additional_entry, p_excerpt,
     p_publish_status, p_read_status, p_package_id);

    return v_book_id;
end;
' language 'plpgsql';





select define_function_args ('bookshelf_book__delete', 'message_id');

create function bookshelf_book__delete (integer)
returns integer as '
declare
    p_book_id                    alias for $1;    
begin
    perform acs_object__delete(p_book_id);
    return 0;    
end;
' language 'plpgsql';





select define_function_args('bookshelf_book__name','book_id');

create function bookshelf_book__name (integer)
returns varchar as '
declare
    p_book_id                    alias for $1;
begin
    return book_author || '': '' || book_title from bookshelf_books where book_id = p_book_id;
end;
' language 'plpgsql';




create function bookshelf_book__read_status_sort_order(
    varchar                     -- read_status
) returns integer
as '
declare
    p_read_status               alias for $1;
    v_sort_order                integer;
begin
    v_sort_order := case p_read_status
        when ''queue''     then 1
        when ''hand''      then 2
        when ''shelf''     then 3
                           else 4
    end;
    
    return v_sort_order;
end;
' language 'plpgsql';




create function bookshelf_book__read_status_pretty(
    varchar                     -- read_status
) returns varchar
as '
declare
    p_read_status               alias for $1;
    v_read_status_pretty        varchar;
begin
    v_read_status_pretty := case p_read_status
        when ''queue''     then ''in the queue''
        when ''hand''      then ''in hand/reading''
        when ''shelf''     then ''in mind/on shelf''
                           else ''''
    end;
    
    return v_read_status_pretty;
end;
' language 'plpgsql';



create function bookshelf_book__pub_status_sort_order(
    varchar                     -- publish_status
) returns integer
as '
declare
    p_publish_status               alias for $1;
    v_sort_order                integer;
begin
    v_sort_order := case p_publish_status
        when ''draft''     then 1
        when ''publish''   then 2
                           else 4
    end;
    
    return v_sort_order;
end;
' language 'plpgsql';




create function bookshelf_book__pub_status_pretty(
    varchar                     -- publish_status
) returns varchar
as '
declare
    p_publish_status               alias for $1;
    v_publish_status_pretty        varchar;
begin
    v_publish_status_pretty := case p_publish_status
        when ''draft''     then ''draft''
        when ''publish''   then ''published''
                           else ''''
    end;
    
    return v_publish_status_pretty;
end;
' language 'plpgsql';



