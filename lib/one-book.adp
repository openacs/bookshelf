<contract>
  Display one bookshelf book

  @author Jeff Davis davis@xarg.net
  @cvs-id $Id$

  @param book array of values as returned from bookshelf::book::get
  @param style string (either "feed" or "display" -- default is display)
  @param base_url url to the package (ok for this to be empty if in the package, trailing / expected)
</contract>
<h1>@book.book_title@ by @book.book_author@</h1>
<p>reviewed by <a href="@book.user_url@">@book.creation_user_first_names@ @book.creation_user_last_name@</a></p>
<p>@book.main_entry@</p>
<p>@book.additional_entry@</p>
<h2>Excerpt</h2>
<p>@book.excerpt@</p>
