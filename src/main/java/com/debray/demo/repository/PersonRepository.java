package com.debray.demo.repository;

import com.debray.demo.entity.Person;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PersonRepository extends JpaRepository<Person, Integer> {
    
    // Custom search methods
    List<Person> findByName(String name);
    
    List<Person> findByNameContainingIgnoreCase(String name);
    
    boolean existsByName(String name);
}
