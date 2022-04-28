-- phpMyAdmin SQL Dump
-- version 5.1.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 28, 2022 at 10:07 AM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 7.4.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `grizzlybase`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_files` (IN `wanted_user` INT)   BEGIN
    DELETE FROM files WHERE user_id = wanted_user;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_folders` (IN `wanted_user` INT)   BEGIN
    DELETE FROM folders WHERE user_id = wanted_user;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_packets` (IN `wanted_user` INT)   BEGIN
    DELETE FROM packets WHERE receiver_id = wanted_user;
    DELETE FROM packets WHERE sender_id = wanted_user;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `logout_procedure` (IN `insert_time` INT, IN `insert_user` INT, IN `insert_storage` INT, IN `insert_num_of_files` INT)   BEGIN
    INSERT INTO details(overall_time, storage_size, user_id, num_of_files) VALUES(insert_time, insert_storage, insert_user, num_of_files);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `details`
--

CREATE TABLE `details` (
  `details_id` int(11) NOT NULL,
  `overall_time` int(11) NOT NULL DEFAULT 0,
  `last_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `storage_size` int(11) NOT NULL DEFAULT 100000000,
  `num_of_files` int(11) NOT NULL DEFAULT 0,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `details`
--

INSERT INTO `details` (`details_id`, `overall_time`, `last_time`, `storage_size`, `num_of_files`, `user_id`) VALUES
(2, 0, '2022-04-27 10:43:01', 100000000, 0, 1),
(4, 0, '2022-04-27 16:27:06', 100000000, 0, 22),
(6, 0, '2022-04-28 07:54:21', 100000000, 0, 23);

-- --------------------------------------------------------

--
-- Table structure for table `files`
--

CREATE TABLE `files` (
  `file_id` int(11) NOT NULL,
  `filename` varchar(64) NOT NULL,
  `filesize` int(11) NOT NULL,
  `filetype` varchar(64) NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `modified_at` datetime NOT NULL DEFAULT current_timestamp(),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `user_id` int(11) NOT NULL,
  `folder_id` int(11) DEFAULT NULL,
  `sanitized_name` varchar(80) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `files`
--

INSERT INTO `files` (`file_id`, `filename`, `filesize`, `filetype`, `deleted`, `modified_at`, `created_at`, `user_id`, `folder_id`, `sanitized_name`) VALUES
(21, 'ZANR__ZGODOVINSKI_ROMAN_4_1.docx', 23065, 'application/vnd.openxmlformats-officedocument.wordprocessingml.d', 0, '2022-04-08 20:45:46', '2022-04-08 20:45:46', 17, NULL, 'a1ad0114ea732c9b945b572a1377a277.docx'),
(22, 'anastazija_earrape.mp3', 596328, 'audio/mpeg', 0, '2022-04-08 20:56:19', '2022-04-08 20:56:19', 17, NULL, '2f8b9712af6d2cc293a82cc936c596b9.mp3');

--
-- Triggers `files`
--
DELIMITER $$
CREATE TRIGGER `storage_size_check` BEFORE INSERT ON `files` FOR EACH ROW BEGIN
        DECLARE storage_size bigint;
        SELECT storage_size FROM details WHERE user_id = NEW.user_id ORDER BY details_id DESC LIMIT 0, 1 INTO storage_size;
        IF (storage_size - NEW.filesize)  <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Storage space used up.';
        END IF;
    END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `folders`
--

CREATE TABLE `folders` (
  `folder_id` int(11) NOT NULL,
  `foldername` varchar(64) NOT NULL,
  `parentfolder_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `modified_at` datetime NOT NULL DEFAULT current_timestamp(),
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `packets`
--

CREATE TABLE `packets` (
  `packet_id` int(11) NOT NULL,
  `file_id` int(11) NOT NULL,
  `receiver_id` int(11) DEFAULT NULL,
  `sender_id` int(11) NOT NULL,
  `edit_perm` tinyint(1) NOT NULL DEFAULT 1,
  `created_packet` datetime NOT NULL DEFAULT current_timestamp(),
  `short_message` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(32) NOT NULL,
  `email` varchar(64) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `modified` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `email`, `password`, `created`, `modified`) VALUES
(1, 'Grizzly', 'TEST', 'test', '2022-04-27 12:43:01', '2022-04-27 16:06:27'),
(17, 'Neva', 'neva.accetto@yahoo.com', '$2y$10$udKDaaflc1YADdImOrCUJeSYR53sk8wba9gJGizBPKi/5Qh3Zq7UO', '2022-03-19 12:34:12', '2022-03-19 11:34:12'),
(22, 'aaaa', 'asd@gmail.com', '$2y$10$vqEe5sNtG8DMSOrRMb/4KO23HWXF26IgJbDQDfEQr51gAX6DHQwjm', '2022-04-27 18:27:06', '2022-04-27 16:27:06'),
(23, 'Test1', 'test@test.com', '$2y$10$mD94Rg0tS2eoSJIyqQXF0O2tgJKLG0VaGB9z6vlwcsDzgMPYqUH8u', '2022-04-28 09:54:21', '2022-04-28 07:54:21');

--
-- Triggers `users`
--
DELIMITER $$
CREATE TRIGGER `after_create_user` AFTER INSERT ON `users` FOR EACH ROW BEGIN
    INSERT INTO details(overall_time, user_id, num_of_files) 
    VALUES(0, NEW.user_id, 0);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_delete_user` AFTER DELETE ON `users` FOR EACH ROW BEGIN
        CALL delete_files(OLD.user_id);
        CALL delete_folders(OLD.user_id);
        CALL delete_packets(OLD.user_id);
    END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `details`
--
ALTER TABLE `details`
  ADD PRIMARY KEY (`details_id`),
  ADD KEY `details_ibfk_1` (`user_id`);

--
-- Indexes for table `files`
--
ALTER TABLE `files`
  ADD PRIMARY KEY (`file_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `folder_id` (`folder_id`);

--
-- Indexes for table `folders`
--
ALTER TABLE `folders`
  ADD PRIMARY KEY (`folder_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `parentfolder_id` (`parentfolder_id`);

--
-- Indexes for table `packets`
--
ALTER TABLE `packets`
  ADD PRIMARY KEY (`packet_id`),
  ADD KEY `file_id` (`file_id`),
  ADD KEY `sender_id` (`sender_id`),
  ADD KEY `receiver_id` (`receiver_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `details`
--
ALTER TABLE `details`
  MODIFY `details_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `files`
--
ALTER TABLE `files`
  MODIFY `file_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `folders`
--
ALTER TABLE `folders`
  MODIFY `folder_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `packets`
--
ALTER TABLE `packets`
  MODIFY `packet_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `details`
--
ALTER TABLE `details`
  ADD CONSTRAINT `details_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `files`
--
ALTER TABLE `files`
  ADD CONSTRAINT `files_ibfk_2` FOREIGN KEY (`folder_id`) REFERENCES `folders` (`folder_id`),
  ADD CONSTRAINT `files_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `folders`
--
ALTER TABLE `folders`
  ADD CONSTRAINT `folders_ibfk_2` FOREIGN KEY (`parentfolder_id`) REFERENCES `folders` (`folder_id`),
  ADD CONSTRAINT `folders_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `packets`
--
ALTER TABLE `packets`
  ADD CONSTRAINT `packets_ibfk_1` FOREIGN KEY (`file_id`) REFERENCES `files` (`file_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `packets_ibfk_2` FOREIGN KEY (`sender_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `packets_ibfk_3` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
