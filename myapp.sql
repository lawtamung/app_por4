-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 04, 2024 at 12:31 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `myapp`
--

-- --------------------------------------------------------

--
-- Table structure for table `growth`
--

CREATE TABLE `growth` (
  `id` int(11) NOT NULL,
  `date` varchar(10) DEFAULT NULL,
  `height` float DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `growth`
--

INSERT INTO `growth` (`id`, `date`, `height`, `user_id`) VALUES
(4, '01/10/2024', 5, NULL),
(5, '02/10/2024', 10, NULL),
(6, '03/10/2024', 15, NULL),
(8, '05/10/2024', 20, NULL),
(10, '06/10/2024', 25, NULL),
(11, '04/10/2024', 17, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `password`, `username`) VALUES
(14, 'nut', '$2y$10$4BE5n7nUJBuJ2s6manFCHuHOavAc2u7Fgi5kvCGpshWTAk9q2TlLm', 'nut'),
(15, 'do', '$2y$10$euwwimDnSc7tMYc/RxFv3OuShR6s3V9Hq27lBX9ZcZqSjk9ByzQ7G', 'donut'),
(16, 'famm', '$2y$10$T0MIkjmTq0in0RogYPDgj.Kk8LvK8D70hQa7NrI3McYIhJZKwB7W2', 'fam'),
(17, 'f', '$2y$10$D/u5Erzv/D20EbkrfFU40uGYVOfxbJ1AF.B1WWFZnJ3E4HR7SA7Ye', 'fam'),
(18, 'fam', '$2y$10$Ap5nPlXo48HP8XHlGK2wEe4TSz9VQFDOaIUc8SFI/.6bJHQkv.8Ma', 'paramat');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `growth`
--
ALTER TABLE `growth`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `growth`
--
ALTER TABLE `growth`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
