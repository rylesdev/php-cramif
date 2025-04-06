create database cramif;


create table users (
    id serial primary key,
    username varchar(50) not null unique,
    email varchar(100) not null unique,
    password varchar(255) not null,
    role varchar(20) default 'user',
    last_password_change timestamp default current_timestamp,
    last_login timestamp,
    login_attempts int default 0,
    is_locked boolean default false
);


create table password_history (
    id serial primary key,
    user_id int references users(id),
    old_password varchar(255),
    change_date timestamp default current_timestamp
);


create table admin_notifications (
    id serial primary key,
    message text,
    notification_date timestamp default current_timestamp
);


insert into users (username, email, password)
values ('john_doe', 'john@example.com', 'hashed_password');


insert into password_history (user_id, old_password)
values (1, 'old_hashed_password');


insert into admin_notifications (message)
values ('l utilisateur john_doe a changé son rôle en admin.');



-- vérifie si le mot de passe d'un utilisateur a expiré avant une mise à jour.
delimiter //

create trigger trigger_check_password_expiration
before update on users
for each row
begin
    if new.last_password_change < now() - interval 90 day then
        signal sqlstate '45000'
        set message_text = 'le mot de passe a expiré. veuillez le changer.';
    end if;
end; //

delimiter ;


-- met à jour le champ last_login après une mise à jour si last_login a changé.
delimiter //

create trigger trigger_update_last_login
after update on users
for each row
begin
    if new.last_login != old.last_login then
        update users
        set last_login = now()
        where id = new.id;
    end if;
end; //

delimiter ;


-- empêche la suppression des utilisateurs ayant le rôle 'admin'.
delimiter //

create trigger trigger_prevent_admin_deletion
before delete on users
for each row
begin
    if old.role = 'admin' then
        signal sqlstate '45000'
        set message_text = 'la suppression des administrateurs est interdite.';
    end if;
end; //

delimiter ;


-- enregistre l'ancien mot de passe dans la table password_history lorsqu'un mot de passe est changé.
delimiter //

create trigger trigger_log_password_change
after update on users
for each row
begin
    if new.password != old.password then
        insert into password_history (user_id, old_password)
        values (old.id, old.password);
    end if;
end; //

delimiter ;


-- empêche la réutilisation d'un mot de passe utilisé au cours de la dernière année.
delimiter //

create trigger trigger_prevent_password_reuse
before update on users
for each row
begin
    if exists (
        select 1
        from password_history
        where user_id = new.id
        and old_password = new.password
        and change_date > now() - interval 1 year
    ) then
        signal sqlstate '45000'
        set message_text = 'vous ne pouvez pas réutiliser un ancien mot de passe.';
    end if;
end; //

delimiter ;


-- notifie les administrateurs lorsqu'un rôle d'utilisateur est modifié.
delimiter //

create trigger trigger_notify_admin_on_role_change
after update on users
for each row
begin
    if new.role != old.role then
        insert into admin_notifications (message)
        values (concat('l`utilisateur ', old.username, ' a changé son rôle en ', new.role, '.'));
    end if;
end; //

delimiter ;