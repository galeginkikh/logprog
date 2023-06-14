implement main
    open core, stdio, file

domains
    gender = муж; жен.

class facts - staffDb
    сотрудник : (string Surname, string Name, integer Age, gender Gender).
    работа : (string Surname, string Job).
    зарплата : (string Surname, real Salary).

class predicates
    printStaff : (). %выводит ФИО сотрудника и его должность.
    salary_more_than : (integer N). % предикат, который выводит сотрудников у которых зарплата больше заданного числа
    staff_age : (integer X). % выводит список сотрудников старше X лет и их должность
    increaseSalary : (integer P). % повышает зарплату всем сотрудникам на указанный процент
    printSalary : (). %вывод сотрудников и их зарплат

clauses
    printStaff() :-
        сотрудник(Surname, Name, _, _),
        работа(Surname, Job),
        write(Surname, " ", Name, " - ", Job),
        nl,
        fail.
    printStaff() :-
        write("Все работники предприятия показаны выше\n\n\n").

clauses
    printSalary() :-
        зарплата(Surname, Salary),
        write(Surname, " - ", Salary),
        nl,
        fail.
    printSalary() :-
        write("\n\n\n").

clauses
    increaseSalary(P) :-
        retract(зарплата(Surname, Salary)),
        asserta(зарплата(Surname, Salary + Salary * P / 100)),
        fail.
    increaseSalary(P) :-
        write("Зарплаты повышены на указанный процент - ", P, "%.\n\n\n").

clauses
    staff_age(X) :-
        сотрудник(Surname, Name, Age, _),
        Age > X,
        работа(Surname, Job),
        write(Name, " ", Age, " лет - ", Job),
        nl,
        fail.
    staff_age(X) :-
        write("Сотрудники старше ", X, " лет.\n\n\n").

clauses
    salary_more_than(N) :-
        зарплата(Surname, Salary),
        Salary > N,
        сотрудник(Surname, Name, _, _),
        write(Name, " ", Surname, "- зарплата: ", Salary),
        nl,
        fail.
    salary_more_than(_).

clauses
    run() :-
        console::init(),
        reconsult("..\\staff.txt", staffDb),
        printStaff(),
        printSalary(),
        write("Введите процент повышения зарплаты: "),
        P = stdio::readLine(),
        increaseSalary(toTerm(P)),
        printSalary(),
        write("Введите возраст: "),
        X = stdio::readLine(),
        staff_age(toTerm(X)),
        write("Введите зарплату: "),
        N = stdio::readLine(),
        salary_more_than(toTerm(N)).

end implement main

goal
    console::runUtf8(main::run).
