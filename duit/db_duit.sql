-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: db_duit
-- ------------------------------------------------------
-- Server version	8.0.37

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accounts` (
  `accountId` int NOT NULL AUTO_INCREMENT,
  `accountName` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `accountEmail` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `accountPassword` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `firstName` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `lastName` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `balance` int NOT NULL,
  PRIMARY KEY (`accountId`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` VALUES (1,'komari','kom1i@gmail.com','komarganteng123','komari','alexander',220000),(2,'komari','kom1di@gmail.com','komarganteng123','komari','alexander',0),(3,'komari','kom2i@gmail.com','komarganteng123','komari','alexander',0),(4,'komari','kom4i@gmail.com','komarganteng123','komari','alexander',0),(5,'dummydummy','dummy@gmail.com','dummy123','dummy','dummy',175000);
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goals`
--

DROP TABLE IF EXISTS `goals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `goals` (
  `goalId` int NOT NULL AUTO_INCREMENT,
  `accountId` int DEFAULT NULL,
  `goalTitle` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `endGoal` int NOT NULL,
  `currentGoal` int DEFAULT NULL,
  PRIMARY KEY (`goalId`),
  KEY `accountId` (`accountId`),
  CONSTRAINT `goals_ibfk_1` FOREIGN KEY (`accountId`) REFERENCES `accounts` (`accountId`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goals`
--

LOCK TABLES `goals` WRITE;
/*!40000 ALTER TABLE `goals` DISABLE KEYS */;
INSERT INTO `goals` VALUES (1,1,'nikahan komari',100000,100000),(5,5,'tabungan nikah',10000000,60000);
/*!40000 ALTER TABLE `goals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transactions` (
  `transactionId` int NOT NULL AUTO_INCREMENT,
  `accountId` int NOT NULL,
  `transactionType` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `categoryName` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `amount` int DEFAULT NULL,
  `timestamps` date DEFAULT NULL,
  PRIMARY KEY (`transactionId`),
  KEY `accountId` (`accountId`),
  CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`accountId`) REFERENCES `accounts` (`accountId`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
INSERT INTO `transactions` VALUES (41,1,'income','Primary','beli motor',10000,'2024-06-13'),(42,1,'income','Primary','beli motor',10000,'2024-06-13'),(43,1,'income','Primary','beli motor',10000,'2024-06-13'),(44,1,'expense','Primary','beli motor',10000,'2024-06-13'),(45,1,'expense','Primary','beli motor',10000,'2024-06-13'),(46,1,'expense','Primary','beli motor',10000,'2024-06-13'),(47,1,'expense','Primary','beli motor',10000,'2024-06-13'),(48,1,'expense','Primary','beli motor',10000,'2024-06-13'),(49,1,'expense','Primary','nikahan komari',10000,'2024-06-21'),(50,1,'expense','Primary','nikahan komari',10000,'2024-06-21'),(51,1,'expense','Primary','nikahan komari',10000,'2024-06-21'),(52,1,'expense','Primary','nikahan komari',10000,'2024-06-21'),(53,1,'expense','Primary','nikahan komari',10000,'2024-06-21'),(54,1,'expense','Primary','nikahan komari',10000,'2024-06-21'),(55,1,'expense','Primary','nikahan komari',10000,'2024-06-21'),(56,1,'expense','Primary','nikahan jede',10000,'2024-06-21'),(57,1,'expense','Primary','asdasdasd',10000,'2024-06-21'),(58,5,'expense','Primary','tabungan nikah',10000,'2024-06-21'),(59,5,'expense','Primary','tabungan nikah',10000,'2024-06-21'),(60,5,'income','Primary','jajan',25000,'2024-06-21'),(61,5,'income','Primary','jajan',10000,'2024-06-21'),(62,5,'income','Primary','uang jajan',10000,'2024-06-21'),(63,5,'expense','Primary','uang jajan',10000,'2024-06-21'),(64,5,'expense','Primary','uang jajan',10000,'2024-06-21'),(65,5,'income','Primary','Jaalan jalan',10000,'2024-06-25'),(66,5,'income','Primary','uang',10000,'2024-06-24'),(67,5,'expense','Primary','jajan',10000,'2024-06-22'),(68,5,'expense','Primary','jajan',10000,'2024-06-24'),(69,5,'expense','Primary','tabungan nikah',10000,'2024-06-21'),(70,5,'expense','Primary','jajan',10000,'2024-06-22'),(71,5,'expense','Primary','jajan',10000,'2024-06-23'),(72,5,'expense','Primary','tabungan nikah',10000,'2024-06-22'),(73,5,'expense','Primary','tabungan nikah',10000,'2024-06-22'),(74,5,'expense','Primary','jajan',10000,'2024-06-21'),(75,1,'income','Primary','tabungan',100000,'2024-06-22'),(76,1,'income','Primary','tabungan',100000,'2024-06-24'),(77,1,'income','Primary','tabungan',10000,'2024-06-25'),(78,5,'income','Primary','tabungan',100000,'2024-06-24'),(79,5,'expense','Primary','tabungan nikah',10000,'2024-06-22');
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-06-22 19:36:33
