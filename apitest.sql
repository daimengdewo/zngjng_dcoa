/*
 Navicat Premium Data Transfer

 Source Server         : apitest
 Source Server Type    : MySQL
 Source Server Version : 50734
 Source Host           : 127.0.0.1:3306
 Source Schema         : apitest

 Target Server Type    : MySQL
 Target Server Version : 50734
 File Encoding         : 65001

 Date: 07/06/2021 21:04:25
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for auth_group
-- ----------------------------
DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of auth_group
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for auth_group_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of auth_group_permissions
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for auth_permission
-- ----------------------------
DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of auth_permission
-- ----------------------------
BEGIN;
INSERT INTO `auth_permission` VALUES (1, 'Can add log entry', 1, 'add_logentry');
INSERT INTO `auth_permission` VALUES (2, 'Can change log entry', 1, 'change_logentry');
INSERT INTO `auth_permission` VALUES (3, 'Can delete log entry', 1, 'delete_logentry');
INSERT INTO `auth_permission` VALUES (4, 'Can view log entry', 1, 'view_logentry');
INSERT INTO `auth_permission` VALUES (5, 'Can add permission', 2, 'add_permission');
INSERT INTO `auth_permission` VALUES (6, 'Can change permission', 2, 'change_permission');
INSERT INTO `auth_permission` VALUES (7, 'Can delete permission', 2, 'delete_permission');
INSERT INTO `auth_permission` VALUES (8, 'Can view permission', 2, 'view_permission');
INSERT INTO `auth_permission` VALUES (9, 'Can add group', 3, 'add_group');
INSERT INTO `auth_permission` VALUES (10, 'Can change group', 3, 'change_group');
INSERT INTO `auth_permission` VALUES (11, 'Can delete group', 3, 'delete_group');
INSERT INTO `auth_permission` VALUES (12, 'Can view group', 3, 'view_group');
INSERT INTO `auth_permission` VALUES (13, 'Can add content type', 4, 'add_contenttype');
INSERT INTO `auth_permission` VALUES (14, 'Can change content type', 4, 'change_contenttype');
INSERT INTO `auth_permission` VALUES (15, 'Can delete content type', 4, 'delete_contenttype');
INSERT INTO `auth_permission` VALUES (16, 'Can view content type', 4, 'view_contenttype');
INSERT INTO `auth_permission` VALUES (17, 'Can add session', 5, 'add_session');
INSERT INTO `auth_permission` VALUES (18, 'Can change session', 5, 'change_session');
INSERT INTO `auth_permission` VALUES (19, 'Can delete session', 5, 'delete_session');
INSERT INTO `auth_permission` VALUES (20, 'Can view session', 5, 'view_session');
INSERT INTO `auth_permission` VALUES (21, 'Can add mouldlist', 6, 'add_mouldlist');
INSERT INTO `auth_permission` VALUES (22, 'Can change mouldlist', 6, 'change_mouldlist');
INSERT INTO `auth_permission` VALUES (23, 'Can delete mouldlist', 6, 'delete_mouldlist');
INSERT INTO `auth_permission` VALUES (24, 'Can view mouldlist', 6, 'view_mouldlist');
INSERT INTO `auth_permission` VALUES (25, 'Can add user', 7, 'add_user');
INSERT INTO `auth_permission` VALUES (26, 'Can change user', 7, 'change_user');
INSERT INTO `auth_permission` VALUES (27, 'Can delete user', 7, 'delete_user');
INSERT INTO `auth_permission` VALUES (28, 'Can view user', 7, 'view_user');
INSERT INTO `auth_permission` VALUES (29, 'Can add Token', 8, 'add_token');
INSERT INTO `auth_permission` VALUES (30, 'Can change Token', 8, 'change_token');
INSERT INTO `auth_permission` VALUES (31, 'Can delete Token', 8, 'delete_token');
INSERT INTO `auth_permission` VALUES (32, 'Can view Token', 8, 'view_token');
INSERT INTO `auth_permission` VALUES (33, 'Can add token', 9, 'add_tokenproxy');
INSERT INTO `auth_permission` VALUES (34, 'Can change token', 9, 'change_tokenproxy');
INSERT INTO `auth_permission` VALUES (35, 'Can delete token', 9, 'delete_tokenproxy');
INSERT INTO `auth_permission` VALUES (36, 'Can view token', 9, 'view_tokenproxy');
COMMIT;

-- ----------------------------
-- Table structure for authtoken_token
-- ----------------------------
DROP TABLE IF EXISTS `authtoken_token`;
CREATE TABLE `authtoken_token` (
  `key` varchar(40) NOT NULL,
  `created` datetime(6) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`key`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `authtoken_token_user_id_35299eff_fk_zjsys_user_id` FOREIGN KEY (`user_id`) REFERENCES `zjsys_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of authtoken_token
-- ----------------------------
BEGIN;
INSERT INTO `authtoken_token` VALUES ('07335e7592a6828fea7c6bac4743e4e6b7d928d2', '2021-06-07 19:57:23.267283', 2);
INSERT INTO `authtoken_token` VALUES ('4e61347a4c0044bf1f8199b30a77104199b2b9b5', '2021-06-07 19:57:32.513265', 1);
COMMIT;

-- ----------------------------
-- Table structure for common_mouldlist
-- ----------------------------
DROP TABLE IF EXISTS `common_mouldlist`;
CREATE TABLE `common_mouldlist` (
  `mouldid` bigint(20) NOT NULL AUTO_INCREMENT,
  `mouldname` varchar(50) NOT NULL,
  `mouldjson` longtext NOT NULL,
  `create_date` varchar(20) NOT NULL,
  `username_id` varchar(150) NOT NULL,
  PRIMARY KEY (`mouldid`),
  KEY `common_mouldlist_username_id_c4bdb0aa_fk_zjsys_user_username` (`username_id`),
  CONSTRAINT `common_mouldlist_username_id_c4bdb0aa_fk_zjsys_user_username` FOREIGN KEY (`username_id`) REFERENCES `zjsys_user` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of common_mouldlist
-- ----------------------------
BEGIN;
INSERT INTO `common_mouldlist` VALUES (2, 'test1', '{\'testjson\':\'testjson\'}', '1623063688', 'admin');
INSERT INTO `common_mouldlist` VALUES (3, 'test11', '{\'testjson\':\'testjson\'}', '1623063691', 'admin');
INSERT INTO `common_mouldlist` VALUES (4, 'test111', '{\'testjson\':\'testjson\'}', '1623063693', 'admin');
INSERT INTO `common_mouldlist` VALUES (5, 'test1111', '{\'testjson\':\'testjson\'}', '1623063695', 'admin');
INSERT INTO `common_mouldlist` VALUES (6, 'test11111', '{\'testjson\':\'testjson\'}', '1623063698', 'admin');
COMMIT;

-- ----------------------------
-- Table structure for django_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_zjsys_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_zjsys_user_id` FOREIGN KEY (`user_id`) REFERENCES `zjsys_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of django_admin_log
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for django_content_type
-- ----------------------------
DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of django_content_type
-- ----------------------------
BEGIN;
INSERT INTO `django_content_type` VALUES (1, 'admin', 'logentry');
INSERT INTO `django_content_type` VALUES (7, 'adminapi', 'user');
INSERT INTO `django_content_type` VALUES (3, 'auth', 'group');
INSERT INTO `django_content_type` VALUES (2, 'auth', 'permission');
INSERT INTO `django_content_type` VALUES (8, 'authtoken', 'token');
INSERT INTO `django_content_type` VALUES (9, 'authtoken', 'tokenproxy');
INSERT INTO `django_content_type` VALUES (6, 'common', 'mouldlist');
INSERT INTO `django_content_type` VALUES (4, 'contenttypes', 'contenttype');
INSERT INTO `django_content_type` VALUES (5, 'sessions', 'session');
COMMIT;

-- ----------------------------
-- Table structure for django_migrations
-- ----------------------------
DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE `django_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of django_migrations
-- ----------------------------
BEGIN;
INSERT INTO `django_migrations` VALUES (1, 'contenttypes', '0001_initial', '2021-05-27 23:29:42.572322');
INSERT INTO `django_migrations` VALUES (2, 'contenttypes', '0002_remove_content_type_name', '2021-05-27 23:29:42.601318');
INSERT INTO `django_migrations` VALUES (3, 'auth', '0001_initial', '2021-05-27 23:29:42.631492');
INSERT INTO `django_migrations` VALUES (4, 'auth', '0002_alter_permission_name_max_length', '2021-05-27 23:29:42.695969');
INSERT INTO `django_migrations` VALUES (5, 'auth', '0003_alter_user_email_max_length', '2021-05-27 23:29:42.700591');
INSERT INTO `django_migrations` VALUES (6, 'auth', '0004_alter_user_username_opts', '2021-05-27 23:29:42.705893');
INSERT INTO `django_migrations` VALUES (7, 'auth', '0005_alter_user_last_login_null', '2021-05-27 23:29:42.709991');
INSERT INTO `django_migrations` VALUES (8, 'auth', '0006_require_contenttypes_0002', '2021-05-27 23:29:42.712000');
INSERT INTO `django_migrations` VALUES (9, 'auth', '0007_alter_validators_add_error_messages', '2021-05-27 23:29:42.716677');
INSERT INTO `django_migrations` VALUES (10, 'auth', '0008_alter_user_username_max_length', '2021-05-27 23:29:42.721466');
INSERT INTO `django_migrations` VALUES (11, 'auth', '0009_alter_user_last_name_max_length', '2021-05-27 23:29:42.725366');
INSERT INTO `django_migrations` VALUES (12, 'auth', '0010_alter_group_name_max_length', '2021-05-27 23:29:42.739895');
INSERT INTO `django_migrations` VALUES (13, 'auth', '0011_update_proxy_permissions', '2021-05-27 23:29:42.745162');
INSERT INTO `django_migrations` VALUES (14, 'adminapi', '0001_initial', '2021-05-27 23:29:42.776696');
INSERT INTO `django_migrations` VALUES (15, 'admin', '0001_initial', '2021-05-27 23:29:42.843740');
INSERT INTO `django_migrations` VALUES (16, 'admin', '0002_logentry_remove_auto_add', '2021-05-27 23:29:42.874393');
INSERT INTO `django_migrations` VALUES (17, 'admin', '0003_logentry_add_action_flag_choices', '2021-05-27 23:29:42.880906');
INSERT INTO `django_migrations` VALUES (18, 'adminapi', '0002_user_password_md5', '2021-05-27 23:29:42.906373');
INSERT INTO `django_migrations` VALUES (19, 'authtoken', '0001_initial', '2021-05-27 23:29:42.921792');
INSERT INTO `django_migrations` VALUES (20, 'authtoken', '0002_auto_20160226_1747', '2021-05-27 23:29:42.965821');
INSERT INTO `django_migrations` VALUES (21, 'authtoken', '0003_tokenproxy', '2021-05-27 23:29:42.968347');
INSERT INTO `django_migrations` VALUES (23, 'sessions', '0001_initial', '2021-05-27 23:29:43.002219');
INSERT INTO `django_migrations` VALUES (27, 'common', '0001_initial', '2021-06-07 18:42:18.220390');
COMMIT;

-- ----------------------------
-- Table structure for django_session
-- ----------------------------
DROP TABLE IF EXISTS `django_session`;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of django_session
-- ----------------------------
BEGIN;
INSERT INTO `django_session` VALUES ('03p2xksjb8yrf8arpw05uhq7sf05k20m', 'NmI5M2Y4MzQ3YzY5YTcyZDMxNWJkYWQ2ZTNlYmExM2Q4YzI0Y2JiMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiIwY2EwNzkyNjFmODA0OTQ3ZjBjYjkwNjEyZTEwM2Q1OWVlYzAxOGQ2In0=', '2021-06-11 17:55:05.467060');
INSERT INTO `django_session` VALUES ('04ku0c4qaay49alxf0ju9ckxddfxjdy4', 'N2UyOTVhNmE0ZjAyZGE1ZjZlOTY0NzVjZWQ5ZGI3OTQzOTUyZTEwZTp7fQ==', '2021-06-11 17:46:49.159052');
INSERT INTO `django_session` VALUES ('1cb7bpjhstyws0ondpnhqggh4lwtkela', 'NmI5M2Y4MzQ3YzY5YTcyZDMxNWJkYWQ2ZTNlYmExM2Q4YzI0Y2JiMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiIwY2EwNzkyNjFmODA0OTQ3ZjBjYjkwNjEyZTEwM2Q1OWVlYzAxOGQ2In0=', '2021-06-20 21:23:45.432317');
INSERT INTO `django_session` VALUES ('1ziz021fxykqdi8y7yp3vda0xihxgfh0', 'NmI5M2Y4MzQ3YzY5YTcyZDMxNWJkYWQ2ZTNlYmExM2Q4YzI0Y2JiMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiIwY2EwNzkyNjFmODA0OTQ3ZjBjYjkwNjEyZTEwM2Q1OWVlYzAxOGQ2In0=', '2021-06-11 22:12:08.374372');
INSERT INTO `django_session` VALUES ('23eecmeieufg2yebh5wpw6lso7f6mbnl', 'N2UyOTVhNmE0ZjAyZGE1ZjZlOTY0NzVjZWQ5ZGI3OTQzOTUyZTEwZTp7fQ==', '2021-06-11 17:43:10.857875');
INSERT INTO `django_session` VALUES ('58m9b4ks6vp1r3oelwosc2ogoq212qm3', 'NmI5M2Y4MzQ3YzY5YTcyZDMxNWJkYWQ2ZTNlYmExM2Q4YzI0Y2JiMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiIwY2EwNzkyNjFmODA0OTQ3ZjBjYjkwNjEyZTEwM2Q1OWVlYzAxOGQ2In0=', '2021-06-11 17:53:48.065480');
INSERT INTO `django_session` VALUES ('62v9shh2aevmab7120ftbz4xco6bllsg', 'N2UyOTVhNmE0ZjAyZGE1ZjZlOTY0NzVjZWQ5ZGI3OTQzOTUyZTEwZTp7fQ==', '2021-06-11 17:47:43.173136');
INSERT INTO `django_session` VALUES ('8bgfk14ogyvgcvv7t63o7xy8z7smyzhk', 'N2UyOTVhNmE0ZjAyZGE1ZjZlOTY0NzVjZWQ5ZGI3OTQzOTUyZTEwZTp7fQ==', '2021-06-11 17:44:42.310679');
INSERT INTO `django_session` VALUES ('8ib9eldue28k2cdr41rp4hcy7qf8ppge', 'YTdiMjc3NzU1OGU0ZjIzOGJlZWU4YTBkZTFlYjI0ZTQwNzdiZDEyYzp7Il9hdXRoX3VzZXJfaWQiOiIyIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiIwMmE4MmUxMjQyNTNjNzBlNzczMzcyNDdiYTNlYjllMjMxMDQ4MGNlIn0=', '2021-06-21 19:57:23.270340');
INSERT INTO `django_session` VALUES ('8pj129rdehx4mo0uy5s6hgtaixbijkhz', 'NmI5M2Y4MzQ3YzY5YTcyZDMxNWJkYWQ2ZTNlYmExM2Q4YzI0Y2JiMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiIwY2EwNzkyNjFmODA0OTQ3ZjBjYjkwNjEyZTEwM2Q1OWVlYzAxOGQ2In0=', '2021-06-21 19:08:41.528233');
INSERT INTO `django_session` VALUES ('8refedz2scpcjwgdwrowiedvj5ijqor9', 'N2UyOTVhNmE0ZjAyZGE1ZjZlOTY0NzVjZWQ5ZGI3OTQzOTUyZTEwZTp7fQ==', '2021-06-11 17:53:19.557516');
INSERT INTO `django_session` VALUES ('aelrmhzry8xv13tghxst16mibl34x9iw', 'NWI4ODFiZDgyMTZiOGE5Y2YxYjFhZTE1M2QxOTJmYmIyNTlhYmQyYzp7Il9hdXRoX3VzZXJfaWQiOiIyIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2YjE1OTVmYmVjNzY2ODAzODcwMTMyMTU1NTFiZGYyNjhmOWVhZGFhIn0=', '2021-06-12 22:46:10.784971');
INSERT INTO `django_session` VALUES ('alkarmfmxl33vqhxk3h38lc9i535p3lg', 'NmI5M2Y4MzQ3YzY5YTcyZDMxNWJkYWQ2ZTNlYmExM2Q4YzI0Y2JiMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiIwY2EwNzkyNjFmODA0OTQ3ZjBjYjkwNjEyZTEwM2Q1OWVlYzAxOGQ2In0=', '2021-06-13 23:03:14.891410');
INSERT INTO `django_session` VALUES ('ay0qndmbs25sv8ryqb05bwyoxuwfwoai', 'N2UyOTVhNmE0ZjAyZGE1ZjZlOTY0NzVjZWQ5ZGI3OTQzOTUyZTEwZTp7fQ==', '2021-06-11 17:46:25.989680');
INSERT INTO `django_session` VALUES ('d35dc2iuljd41qc40a4u9umn649lke0r', 'NmI5M2Y4MzQ3YzY5YTcyZDMxNWJkYWQ2ZTNlYmExM2Q4YzI0Y2JiMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiIwY2EwNzkyNjFmODA0OTQ3ZjBjYjkwNjEyZTEwM2Q1OWVlYzAxOGQ2In0=', '2021-06-11 18:46:51.236922');
INSERT INTO `django_session` VALUES ('d9u5rxo376kbug109lbb3hqgfw6a5hjv', 'NmI5M2Y4MzQ3YzY5YTcyZDMxNWJkYWQ2ZTNlYmExM2Q4YzI0Y2JiMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiIwY2EwNzkyNjFmODA0OTQ3ZjBjYjkwNjEyZTEwM2Q1OWVlYzAxOGQ2In0=', '2021-06-12 22:16:28.091639');
INSERT INTO `django_session` VALUES ('de32k3bp342o9mrvjex8k418332h31nq', 'NmI5M2Y4MzQ3YzY5YTcyZDMxNWJkYWQ2ZTNlYmExM2Q4YzI0Y2JiMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiIwY2EwNzkyNjFmODA0OTQ3ZjBjYjkwNjEyZTEwM2Q1OWVlYzAxOGQ2In0=', '2021-06-21 19:38:54.655787');
INSERT INTO `django_session` VALUES ('f2v5l6f980ltczqxev1ydczxvlxak7ia', 'NmI5M2Y4MzQ3YzY5YTcyZDMxNWJkYWQ2ZTNlYmExM2Q4YzI0Y2JiMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiIwY2EwNzkyNjFmODA0OTQ3ZjBjYjkwNjEyZTEwM2Q1OWVlYzAxOGQ2In0=', '2021-06-11 19:03:59.018809');
INSERT INTO `django_session` VALUES ('fkqhif1gf9pba2687e61v1bq8svjiuwi', 'NmI5M2Y4MzQ3YzY5YTcyZDMxNWJkYWQ2ZTNlYmExM2Q4YzI0Y2JiMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiIwY2EwNzkyNjFmODA0OTQ3ZjBjYjkwNjEyZTEwM2Q1OWVlYzAxOGQ2In0=', '2021-06-12 22:13:24.514348');
INSERT INTO `django_session` VALUES ('ihb9p4snat60nohp98j26ie7buq5xast', 'NmI5M2Y4MzQ3YzY5YTcyZDMxNWJkYWQ2ZTNlYmExM2Q4YzI0Y2JiMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiIwY2EwNzkyNjFmODA0OTQ3ZjBjYjkwNjEyZTEwM2Q1OWVlYzAxOGQ2In0=', '2021-06-11 18:28:43.481523');
INSERT INTO `django_session` VALUES ('kf23tzpgzgvxwta5o07ff4uvldarzdid', 'NmI5M2Y4MzQ3YzY5YTcyZDMxNWJkYWQ2ZTNlYmExM2Q4YzI0Y2JiMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiIwY2EwNzkyNjFmODA0OTQ3ZjBjYjkwNjEyZTEwM2Q1OWVlYzAxOGQ2In0=', '2021-06-11 20:52:03.142196');
INSERT INTO `django_session` VALUES ('l4tt43sggu6mdtpq3vowb7xmqn5jj9ty', 'NmI5M2Y4MzQ3YzY5YTcyZDMxNWJkYWQ2ZTNlYmExM2Q4YzI0Y2JiMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiIwY2EwNzkyNjFmODA0OTQ3ZjBjYjkwNjEyZTEwM2Q1OWVlYzAxOGQ2In0=', '2021-06-15 19:58:58.959313');
INSERT INTO `django_session` VALUES ('mkp3xhkgyvncsaxjsvc9yqhh3f5mpl2n', 'N2UyOTVhNmE0ZjAyZGE1ZjZlOTY0NzVjZWQ5ZGI3OTQzOTUyZTEwZTp7fQ==', '2021-06-11 17:52:59.814687');
INSERT INTO `django_session` VALUES ('mvowx4g4taelhljpc4crk1sgea844fy7', 'NmI5M2Y4MzQ3YzY5YTcyZDMxNWJkYWQ2ZTNlYmExM2Q4YzI0Y2JiMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiIwY2EwNzkyNjFmODA0OTQ3ZjBjYjkwNjEyZTEwM2Q1OWVlYzAxOGQ2In0=', '2021-06-11 21:10:43.993508');
INSERT INTO `django_session` VALUES ('p3k6o58xwcypvn866g47a8kjzc9nsmct', 'NmI5M2Y4MzQ3YzY5YTcyZDMxNWJkYWQ2ZTNlYmExM2Q4YzI0Y2JiMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiIwY2EwNzkyNjFmODA0OTQ3ZjBjYjkwNjEyZTEwM2Q1OWVlYzAxOGQ2In0=', '2021-06-15 22:52:52.514416');
INSERT INTO `django_session` VALUES ('pft5volr55vsm3g9nvrlxsmirr5qs4xr', 'NWI4ODFiZDgyMTZiOGE5Y2YxYjFhZTE1M2QxOTJmYmIyNTlhYmQyYzp7Il9hdXRoX3VzZXJfaWQiOiIyIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2YjE1OTVmYmVjNzY2ODAzODcwMTMyMTU1NTFiZGYyNjhmOWVhZGFhIn0=', '2021-06-12 22:28:41.656147');
INSERT INTO `django_session` VALUES ('qgvl5b2rf3gj4ky9jxlhwbsgcltbimm5', 'N2UyOTVhNmE0ZjAyZGE1ZjZlOTY0NzVjZWQ5ZGI3OTQzOTUyZTEwZTp7fQ==', '2021-06-11 17:49:54.068411');
INSERT INTO `django_session` VALUES ('qo3tqt00t5lgqa5y2wq6tkt2fm6eb63d', 'NmI5M2Y4MzQ3YzY5YTcyZDMxNWJkYWQ2ZTNlYmExM2Q4YzI0Y2JiMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiIwY2EwNzkyNjFmODA0OTQ3ZjBjYjkwNjEyZTEwM2Q1OWVlYzAxOGQ2In0=', '2021-06-11 17:52:35.882045');
INSERT INTO `django_session` VALUES ('skv04elrndnn44rk6fk6pn1jrkk8feth', 'NmI5M2Y4MzQ3YzY5YTcyZDMxNWJkYWQ2ZTNlYmExM2Q4YzI0Y2JiMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiIwY2EwNzkyNjFmODA0OTQ3ZjBjYjkwNjEyZTEwM2Q1OWVlYzAxOGQ2In0=', '2021-06-12 22:46:25.975326');
INSERT INTO `django_session` VALUES ('th1tk4gs410uct0djoezbb3whhvnrj07', 'YzE3YjRiMzQwNDk4Mzc4ZDlhNmY2YTA2YWFkNjUzNWQzYjJmNjk0ZDp7Il9hdXRoX3VzZXJfaWQiOiIyIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI3OThjMTg1ZDVjMGJhZjgxNTdhYWUzMThjN2I0ZGMzNTA5OWNiNGY2In0=', '2021-06-12 22:24:14.205461');
INSERT INTO `django_session` VALUES ('wk6tdei0ph85e358zhitqgywtn7t05nx', 'NmI5M2Y4MzQ3YzY5YTcyZDMxNWJkYWQ2ZTNlYmExM2Q4YzI0Y2JiMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiIwY2EwNzkyNjFmODA0OTQ3ZjBjYjkwNjEyZTEwM2Q1OWVlYzAxOGQ2In0=', '2021-06-21 19:57:32.516312');
INSERT INTO `django_session` VALUES ('xj2j2lw4i7m2u4sthu7m1uajfph1ygn4', 'NmI5M2Y4MzQ3YzY5YTcyZDMxNWJkYWQ2ZTNlYmExM2Q4YzI0Y2JiMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiIwY2EwNzkyNjFmODA0OTQ3ZjBjYjkwNjEyZTEwM2Q1OWVlYzAxOGQ2In0=', '2021-06-11 17:52:04.491284');
INSERT INTO `django_session` VALUES ('xxsnve2i35n0isgsan5j8zmq8qsi0ptw', 'NmI5M2Y4MzQ3YzY5YTcyZDMxNWJkYWQ2ZTNlYmExM2Q4YzI0Y2JiMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiIwY2EwNzkyNjFmODA0OTQ3ZjBjYjkwNjEyZTEwM2Q1OWVlYzAxOGQ2In0=', '2021-06-13 23:10:30.323827');
INSERT INTO `django_session` VALUES ('yjb0hwf3dz943d7aam9yyuuz19rkv83m', 'N2UyOTVhNmE0ZjAyZGE1ZjZlOTY0NzVjZWQ5ZGI3OTQzOTUyZTEwZTp7fQ==', '2021-06-11 17:43:49.277055');
INSERT INTO `django_session` VALUES ('zu21p57h7hnbzd18w754d3b4pgwbn3uc', 'NmI5M2Y4MzQ3YzY5YTcyZDMxNWJkYWQ2ZTNlYmExM2Q4YzI0Y2JiMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiIwY2EwNzkyNjFmODA0OTQ3ZjBjYjkwNjEyZTEwM2Q1OWVlYzAxOGQ2In0=', '2021-06-21 18:59:19.507178');
COMMIT;

-- ----------------------------
-- Table structure for zjsys_user
-- ----------------------------
DROP TABLE IF EXISTS `zjsys_user`;
CREATE TABLE `zjsys_user` (
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `usertype` int(10) unsigned NOT NULL,
  `realname` varchar(30) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `password_md5` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `zjsys_user_realname_299ec0d8` (`realname`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of zjsys_user
-- ----------------------------
BEGIN;
INSERT INTO `zjsys_user` VALUES ('pbkdf2_sha256$150000$InvEIgGrohkb$NswZkEL9JE1tJLonDBCfE4b2QFqg83MyTTmQOeHbRGU=', '2021-06-07 19:57:32.507752', 1, 'admin', '', '', '', 0, 1, '2021-05-27 23:30:50.745534', 1, 9, 'admin', '', 'P1AmyxcTf8LBdcYFvbMwbg==');
INSERT INTO `zjsys_user` VALUES ('pbkdf2_sha256$150000$TZ08dcOxLT5m$007ikUxDG7r1u2MHFQCw5ZLUv/EfxRRZ1ElfWLomXuI=', '2021-06-07 19:57:23.263354', 1, 'test', '', '', '', 0, 1, '2021-05-28 18:48:32.358689', 2, 1, 'test', '', 'y418Gdnk8cIyiAmjJeNavg==');
COMMIT;

-- ----------------------------
-- Table structure for zjsys_user_groups
-- ----------------------------
DROP TABLE IF EXISTS `zjsys_user_groups`;
CREATE TABLE `zjsys_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `zjsys_user_groups_user_id_group_id_dbf80b0a_uniq` (`user_id`,`group_id`),
  KEY `zjsys_user_groups_group_id_39119293_fk_auth_group_id` (`group_id`),
  CONSTRAINT `zjsys_user_groups_group_id_39119293_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `zjsys_user_groups_user_id_17e8f696_fk_zjsys_user_id` FOREIGN KEY (`user_id`) REFERENCES `zjsys_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of zjsys_user_groups
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for zjsys_user_user_permissions
-- ----------------------------
DROP TABLE IF EXISTS `zjsys_user_user_permissions`;
CREATE TABLE `zjsys_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `zjsys_user_user_permissions_user_id_permission_id_31aecb0a_uniq` (`user_id`,`permission_id`),
  KEY `zjsys_user_user_perm_permission_id_76ff7d8d_fk_auth_perm` (`permission_id`),
  CONSTRAINT `zjsys_user_user_perm_permission_id_76ff7d8d_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `zjsys_user_user_permissions_user_id_6e008fe2_fk_zjsys_user_id` FOREIGN KEY (`user_id`) REFERENCES `zjsys_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of zjsys_user_user_permissions
-- ----------------------------
BEGIN;
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
