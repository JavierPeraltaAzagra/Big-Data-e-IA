let taskList = document.getElementById('task-list');
let newTaskInput = document.getElementById('new-task');

function addTask() {
    let taskText = newTaskInput.value.trim();
    if (taskText !== '') {
        let li = document.createElement('li');
        li.textContent = taskText;
        li.addEventListener('click', function() {
            this.classList.toggle('completed');
        });
        li.appendChild(createDeleteButton());
        taskList.appendChild(li);
        newTaskInput.value = '';
    }
}

function createDeleteButton() {
    let button = document.createElement('button');
    button.textContent = 'Eliminar';
    button.onclick = function() {
        this.parentNode.remove();
    };
    return button;
}