<master>
<property name="title">@title;noquote@</property>
<property name="header_stuff">
  <style>
  div.bookshelf_navbar { 
      text-align: right;
      font-size: 80%;
      font-weight: bold;
      background: #41329c; 
      padding: 3px 1em 3px 0;
      color: white;
  }
  .bookshelf_navbar a:link,
  .bookshelf_navbar a:visited {
      color: white; 
      text-decoration: none;
  }
  .bookshelf_navbar a:hover { 
      color: white; 
      text-decoration: underline; 
  }
  INPUT.bookshelf_navbar { font-family: tahoma,verdana,arial,helvetica; font-weight: bold; font-size: 70%; color: black; }
  .bookshelf_summary { font-size: 70%; font-family: verdana,arial,helvetica; }
  .bookshelf_summary_bold { font-size: 70%; font-family: verdana,arial,helvetica; font-weight: bold; }
  </style>
</property>
<if @signatory@ not nil><property name="signatory">@signatory@</property></if>
<if @displayed_object_id@ not nil><property name="displayed_object_id">@displayed_object_id@</property></if>
<if @focus@ not nil><property name="focus">@focus;noquote@</property></if>
<if @context_bar@ not nil><property name="context_bar">@context_bar;noquote@</property></if>

<include src="nav-bar">

<p>

<slave>

<p>

<include src="nav-bar">
