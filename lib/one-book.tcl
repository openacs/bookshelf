if {![info exists book(user_url)]} {
    set book(user_url) [acs_community_member_url -user_id $book(creation_user)]
}
