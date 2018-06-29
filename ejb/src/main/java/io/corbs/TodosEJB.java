package io.corbs;

import javax.ejb.Stateful;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Stateful
public class TodosEJB {

    private static int limit = Integer.valueOf(System.getProperty("todos.api.limit", "25"));

    private static Integer seq = 0;

    private final LinkedHashMap<Integer, Todo> todos = new LinkedHashMap<Integer, Todo>() {
        @Override
        protected boolean removeEldestEntry(final Map.Entry eldest) {
            return size() > limit;
        }
    };

    public Todo retrieve(Integer id) {
        return null;
    }

    public List<Todo> retrieve() {
        return Collections.emptyList();
    }

    public void delete(Integer id) {

    }

    public void update(Integer id, Todo todo) {

    }

    public Todo create(Todo todo) {
        Todo t = new Todo(seq++);
        t.setCompleted(todo.getCompleted());
        t.setTitle(todo.getTitle());
        todos.put(t.getId(), t);
        return todos.get(t.getId());
    }
}
