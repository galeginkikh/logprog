implement main
    open core, stdio, file

domains
    gender = муж; жен.
    работник = работник(string Surname, string Name, string Job).
    доход = доход(string Surname, string Name, real Salary).

class facts - staffDb
    сотрудник : (string Surname, string Name, integer Age, gender Gender).
    работа : (string Surname, string Job).
    зарплата : (string Surname, real Salary).
    отдел : (string Surname, string Department).

class predicates  %Вспомогательные предикаты
    длина : (A*) -> integer K.
    сумма_элем : (real* List) -> real Sum.
    среднее_списка : (real* List) -> real Average determ.

clauses
    длина([]) = 0.
    длина([_ | T]) = длина(T) + 1.

    сумма_элем([]) = 0.
    сумма_элем([H | T]) = сумма_элем(T) + H.

    среднее_списка(L) = сумма_элем(L) / длина(L) :-
        длина(L) > 0.

class predicates
    выплата_зарплаты : (integer N) -> доход* Зарплаты. % предикат, который выводит сотрудников у которых зарплата больше заданного числа
    работники_отдела : (string D) -> работник* Отдел determ. % предикат, который выводит сотрудников, находящихся в отделе
    количество_сотрудников : (string D) -> integer K determ.
    суммарный_доход_работников_в_отделе : (string D) -> real Доход determ.
    средняя_зарплата_в_отделе : (string D) -> real Среднее determ.
    женщины_предприятия : () -> работник* Женщины determ.
    отделы_в_которых_есть_профессия : (string Job) -> string* Название.

clauses
    выплата_зарплаты(N) = SalaryList :-
        !,
        SalaryList =
            [ доход(Surname, Name, Salary) ||
                сотрудник(Surname, Name, _, _),
                зарплата(Surname, Salary),
                Salary > N
            ].

clauses
    работники_отдела(D) =
            [ работник(Surname, Name, Job) ||
                сотрудник(Surname, Name, _, _),
                работа(Surname, Job),
                отдел(Surname, D)
            ] :-
        !.

clauses
    суммарный_доход_работников_в_отделе(D) =
            сумма_элем(
                [ Salary ||
                    отдел(Surname, D),
                    зарплата(Surname, Salary)
                ]) :-
        !.

clauses
    количество_сотрудников(D) = длина(работники_отдела(D)).

clauses
    средняя_зарплата_в_отделе(D) =
        среднее_списка(
            [ Salary ||
                отдел(Surname, D),
                зарплата(Surname, Salary)
            ]).

clauses
    женщины_предприятия() =
            [ работник(Surname, Name, Job) ||
                сотрудник(Surname, Name, _, жен),
                работа(Surname, Job)
            ] :-
        !.

clauses
    отделы_в_которых_есть_профессия(J) = JobList :-
        JobList =
            [ Y ||
                работа(Surname, J),
                отдел(Surname, Y)
            ],
        !.

class predicates  %Вывод на экран
    write_доход : (доход* Выплата_зарплаты).
    write_работник : (работник* Работники_отдела).

clauses
    write_доход(L) :-
        foreach доход(Surname, Name, Salary) = list::getMember_nd(L) do
            writef("%-15s %-15s %10.2f\n", Surname, Name, Salary),
            writef("________________________________________________\n")
        end foreach.

clauses
    write_работник(L) :-
        foreach работник(Surname, Name, Job) = list::getMember_nd(L) do
            writef("%-15s %-15s %-15s\n", Surname, Name, Job),
            writef("_______________________________________________________\n")
        end foreach.

clauses
    run() :-
        console::init(),
        reconsult("..\\staff.txt", staffDb),
        fail.
    run() :-
        write("Введите зарплату: "),
        N = stdio::readLine(),
        write("Список сотрудников с зарплатой больше ", N, ":\n\n"),
        writef(string::format("%-15s %-15s %-15s\n", "Фамилия", "Имя", "Зарплата")),
        writef("________________________________________________\n"),
        writef("________________________________________________\n"),
        write_доход(выплата_зарплаты(toTerm(N))),
        write("\n\n\n"),
        fail.
    run() :-
        write("Введите название отдела: "),
        D = stdio::readLine(),
        write("Список сотрудников отдела: ", D, "\n\n"),
        writef(string::format("%-15s %-15s %-15s\n", "Фамилия", "Имя", "Должность")),
        writef("_______________________________________________________\n"),
        writef("_______________________________________________________\n"),
        write_работник(работники_отдела(D)),
        write("\nВсего работает в отделе = ", количество_сотрудников(D), "\n"),
        write("\nДоход всех сотрудников отдела в сумме: ", суммарный_доход_работников_в_отделе(D), "\n"),
        write("\nCредняя зарплата в отделе: ", средняя_зарплата_в_отделе(D), "\n"),
        writef("_______________________________________________________\n\n\n"),
        nl,
        fail.
    run() :-
        write("Женщины предприятия:\n"),
        write_работник(женщины_предприятия()),
        nl,
        fail.
    run() :-
        J = "директор",
        write("Отделы, в которых есть профессия ", J, ": "),
        write(отделы_в_которых_есть_профессия(J)),
        fail.
    run() :-
        succeed.

end implement main

goal
    console::run(main::run).
