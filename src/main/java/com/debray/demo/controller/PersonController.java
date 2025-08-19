package com.debray.demo.controller;

import com.debray.demo.entity.Person;
import com.debray.demo.repository.PersonRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/persons")
public class PersonController {

    @Autowired
    private PersonRepository personRepository;

    // Récupérer toutes les personnes
    @GetMapping
    public List<Person> getAllPersons() {
        return personRepository.findAll();
    }

    // Récupérer une personne par ID
    @GetMapping("/{id}")
    public ResponseEntity<Person> getPersonById(@PathVariable Integer id) {
        Optional<Person> person = personRepository.findById(id);
        return person.map(ResponseEntity::ok)
                    .orElse(ResponseEntity.notFound().build());
    }

    // Créer une nouvelle personne
    @PostMapping
    public ResponseEntity<Person> createPerson(@RequestBody Person person) {
        // Validation basique
        if (person.getName() == null || person.getName().trim().isEmpty()) {
            return ResponseEntity.badRequest().build();
        }
        
        Person savedPerson = personRepository.save(person);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedPerson);
    }

    // Mettre à jour une personne
    @PutMapping("/{id}")
    public ResponseEntity<Person> updatePerson(@PathVariable Integer id, @RequestBody Person personDetails) {
        Optional<Person> optionalPerson = personRepository.findById(id);
        
        if (optionalPerson.isPresent()) {
            Person person = optionalPerson.get();
            person.setName(personDetails.getName());
            person.setData(personDetails.getData());
            
            Person updatedPerson = personRepository.save(person);
            return ResponseEntity.ok(updatedPerson);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // Supprimer une personne
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletePerson(@PathVariable Integer id) {
        if (personRepository.existsById(id)) {
            personRepository.deleteById(id);
            return ResponseEntity.noContent().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // Rechercher par nom
    @GetMapping("/search")
    public List<Person> searchByName(@RequestParam String name) {
        return personRepository.findByNameContainingIgnoreCase(name);
    }
}
