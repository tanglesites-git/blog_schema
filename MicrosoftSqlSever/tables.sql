drop table if exists [post_comment_reply];
drop table if exists [post_comment];
drop table if exists [user_role];
drop table if exists [post_tag];
drop table if exists [post_category];
drop table if exists [user_tag];
drop table if exists [user_category];
drop table if exists [post];
drop table if exists [user];
drop table if exists [role];
drop table if exists [category];
drop table if exists [tag];

-- create the role table
create table [role]
(
    [id]                    int          not null,
    [name]                  varchar(100) not null,
    [normalized_name]       varchar(100) not null,
    [date_created]          timestamp    not null,
    [concurrency_timestamp] varchar(36)  not null,
    constraint pk_role_id primary key ([id])
);

create index idx_role_normalized_name on [role] ([normalized_name]);
create index idx_role_date_created on [role] ([date_created]);

---------------------------------------------------------------------------------------------------------------------

-- create the user table
create table [user]
(
    [id]                    int          not null,
    [first_name]            int          not null,
    [last_name]             int          not null,
    [normalized_first_name] varchar(100) not null,
    [normalized_last_name]  varchar(100) not null,
    [username]              varchar(100) not null,
    [normalized_username]   varchar(100) not null,
    [date_created]          timestamp    not null,
    [email]                 varchar(100) not null,
    [normalized_email]      varchar(100) not null,
    [password_hash]         varchar(255) not null,
    [city]                  varchar(100) not null,
    [state]                 varchar(100) not null,
    [email_verified]        smallint     not null default 0,
    [concurrency_timestamp] varchar(36)  not null,
    [lockout_enabled]       smallint     not null default 0,
    [two_factored_enabled]  smallint     not null default 0,
    constraint pk_user_id primary key ([id])
);

create index idx_user_normalized_email on [user] ([normalized_email]);
create index idx_user_normalized_first_name_normalized_last_name on [user] ([normalized_first_name], [normalized_last_name]);
create index idx_user_date_created on [user] ([date_created]);
create index idx_user_city_state on [user] ([city], [state]);
create index idx_user_email_verified on [user] ([email_verified]);
---------------------------------------------------------------------------------------------------------------------

-- create the post table
create table [post]
(
    [id]                  int                                not null,
    [title]               varchar(100)                       not null,
    [normalized_title]    varchar(100)                       not null,
    [subtitle]            varchar(150)                       not null,
    [normalized_subtitle] varchar(150)                       not null,
    [content]             varchar(max)                       not null,
    [content_length]      int                                not null,
    [content_preview]     varchar(255)                       not null,
    [word_count]          int                                not null,
    [slug]                varchar(100)                       not null,
    [date_created]        datetime                           not null,
    [date_updated]        datetime default current_timestamp not null,
    [user_id]             int                                not null,
    constraint pk_post_id primary key ([id]),
    constraint fk_user_id foreign key ([user_id]) references [user] ([id])
);

create index idx_post_normalized_title_normalized_subtitle on [post] ([normalized_title], [normalized_subtitle]);
create index idx_post_slug on [post] ([slug]);
create index idx_post_date_created on [post] ([date_created]);
create index idx_post_date_updated on [post] ([date_updated]);
create index idx_post_word_count on [post] ([word_count]);
create index idx_post_content_preview on [post] ([content_preview]);
---------------------------------------------------------------------------------------------------------------------

-- create the user_role table
create table [user_role]
(
    [user_id] int not null,
    [role_id] int not null,
    constraint pk_user_role_user_id_role_id primary key ([user_id], [role_id]),
    constraint fk_user_role_user_id foreign key ([user_id]) references [user] ([id]),
    constraint fk_user_role_role_id foreign key ([role_id]) references [role] ([id])
);
---------------------------------------------------------------------------------------------------------------------

-- create the post_comment table
create table [post_comment]
(
    [id]              int                                not null,
    [content]         varchar(max)                       not null,
    [content_length]  int                                not null,
    [content_preview] varchar(255)                       not null,
    [word_count]      int                                not null,
    [date_created]    datetime                           not null,
    [date_updated]    datetime default current_timestamp not null,
    [user_id]         int                                not null,
    [post_id]         int                                not null,
    constraint pk_post_comment_id primary key ([id]),
    constraint fk_post_comment_user_id foreign key ([user_id]) references [user] ([id]),
    constraint fk_post_comment_post_id foreign key ([post_id]) references [post] ([id])
);

create index idx_post_comment_date_created on [post_comment] ([date_created]);
create index idx_post_comment_date_updated on [post_comment] ([date_updated]);
---------------------------------------------------------------------------------------------------------------------

-- create the post_comment_reply table
create table [post_comment_reply]
(
    [id]              int                                not null,
    [content]         varchar(max)                       not null,
    [content_length]  int                                not null,
    [content_preview] varchar(255)                       not null,
    [word_count]      int                                not null,
    [date_created]    datetime                           not null,
    [date_updated]    datetime default current_timestamp not null,
    [user_id]         int                                not null,
    [post_comment_id] int                                not null,
    constraint pk_post_comment_reply_id primary key ([id]),
    constraint fk_post_comment_reply_user_id foreign key ([user_id]) references [user] ([id]),
    constraint fk_post_comment_reply_post_comment_id foreign key ([post_comment_id]) references [post_comment] ([id])
);

create index idx_post_comment_reply_date_created on [post_comment_reply] ([date_created]);
create index idx_post_comment_reply_date_updated on [post_comment_reply] ([date_updated]);
---------------------------------------------------------------------------------------------------------------------


-- create the category table
create table [category]
(
    [id]            int          not null,
    [name]          varchar(100) not null,
    normalized_name varchar(100) not null,
    [date_created]  timestamp    not null,
    constraint pk_category_id primary key (id)
);

create index idx_category_normalized_name on [category] ([normalized_name]);
create index idx_category_date_created on [category] ([date_created]);
---------------------------------------------------------------------------------------------------------------------


-- create the tag table
create table [tag]
(
    [id]              int          not null,
    [name]            varchar(100) not null,
    [normalized_name] varchar(100) not null,
    [date_created]    timestamp    not null,
    constraint pk_tag_id primary key (id)
);

create index idx_tag_normalized_name on [tag] ([normalized_name]);
create index idx_tag_date_created on [tag] ([date_created]);
---------------------------------------------------------------------------------------------------------------------


-- create the post_category table
create table [post_category]
(
    [post_id]     int not null,
    [category_id] int not null,
    constraint pk_post_id_category_id primary key ([post_id], [category_id]),
    constraint fk_post_category_post_id foreign key ([post_id]) references [post] (id),
    constraint fk_post_category_category_id foreign key ([category_id]) references category ([id])
);
---------------------------------------------------------------------------------------------------------------------


-- create the post_tag table
create table [post_tag]
(
    [post_id] int not null,
    [tag_id]  int not null,
    constraint pk_post_id_tag_id primary key ([post_id], [tag_id]),
    constraint fk_post_tag_post_id foreign key ([post_id]) references [post] ([id]),
    constraint fk_post_tag_tag_id foreign key ([tag_id]) references [tag] ([id])
);
---------------------------------------------------------------------------------------------------------------------


-- create the user_category table
create table [user_category]
(
    [user_id]     int not null,
    [category_id] int not null,
    constraint pk_user_id_category_id primary key ([user_id], [category_id]),
    constraint fk_user_category_user_id foreign key ([user_id]) references [user] ([id]),
    constraint fk_user_category_category_id foreign key ([category_id]) references [category] ([id])
);
---------------------------------------------------------------------------------------------------------------------


-- create the user_tag table
create table [user_tag]
(
    [user_id] int not null,
    [tag_id]  int not null,
    constraint pk_user_tag_user_id_tag_id primary key ([user_id], [tag_id]),
    constraint fk_user_tag_user_id foreign key ([user_id]) references [user] ([id]),
    constraint fk_user_tag_tag_id foreign key ([tag_id]) references [tag] ([id])
);
---------------------------------------------------------------------------------------------------------------------