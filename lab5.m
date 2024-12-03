% Лабораторная работа №5: Изучение программных инструментов Octave
% Цель: Ознакомление с комплектом функций Octave/Scilab/Matlab для анализа сигналов

pkg load signal;  % Загружаем пакет Signal для работы с фильтрами

% =========================
% 1. Генерация прототипов аналоговых фильтров
% =========================

printf("1. Генерация прототипов аналоговых фильтров:\n");

% Баттерворт (3-го порядка)
[n_butter, wn_butter] = buttap(3);
disp('Баттерворт (3-й порядок):');
disp(n_butter);
disp(wn_butter);

% Чебышев 1-го рода (пульсации 0.5 дБ)
[b_cheb1, a_cheb1] = cheb1ap(3, 0.5);
disp('Чебышев 1-го рода (пульсации 0.5 дБ):');
disp(b_cheb1);
disp(a_cheb1);

% Чебышев 2-го рода (затухание 40 дБ)
[b_cheb2, a_cheb2] = cheb2ap(3, 40);
disp('Чебышев 2-го рода (затухание 40 дБ):');
disp(b_cheb2);
disp(a_cheb2);

% Эллиптический фильтр (пульсации 0.5 дБ, затухание 40 дБ)
[b_ellip, a_ellip] = ellipap(3, 0.5, 40);
disp('Эллиптический фильтр (пульсации 0.5 дБ, затухание 40 дБ):');
disp(b_ellip);
disp(a_ellip);

% Бесселев фильтр
[b_bessel, a_bessel] = besselap(3);
disp('Бесселев фильтр:');
disp(b_bessel);
disp(a_bessel);

% =========================
% 3. Трансформация фильтров
% =========================

printf("\n3. Трансформация фильтров:\n");

% Прототип НЧ-фильтра Баттерворта (3-го порядка)
[num_lp, den_lp] = butter(3, 0.5, 's');
disp('Прототип НЧ фильтра (Баттерворт):');
disp(num_lp);
disp(den_lp);

% Реализация НЧ -> ВЧ вручную
function [num_hp, den_hp] = lp2hp_custom(num_lp, den_lp, omega_c)
    % Преобразование НЧ -> ВЧ вручную
    s = tf('s');                     % Переменная Лапласа
    H_lp = tf(num_lp, den_lp);       % Передаточная функция НЧ
    H_hp = H_lp * (omega_c / s);     % Замена переменной
    [num_hp, den_hp] = tfdata(H_hp, 'vector');  % Получение коэффициентов
end

omega_hp = 1; % Центральная частота для преобразования
[num_hp, den_hp] = lp2hp_custom(num_lp, den_lp, omega_hp);
disp('НЧ -> ВЧ (вручную):');
disp(num_hp);
disp(den_hp);

% НЧ -> Полосозаградительный (ручное преобразование)
function [num_bs, den_bs] = lp2bs_custom(num_lp, den_lp, omega_bs)
    omega_1 = omega_bs(1);
    omega_2 = omega_bs(2);
    omega_0 = sqrt(omega_1 * omega_2); % Центральная частота
    bandwidth = omega_2 - omega_1;

    % Создаем передаточную функцию НЧ
    s = tf('s');
    H_lp = tf(num_lp, den_lp);

    % Преобразование НЧ -> ПЗ
    H_bs = H_lp * ((s^2 + omega_0^2) / (bandwidth * s));
    [num_bs, den_bs] = tfdata(H_bs, 'vector');
end

% Пример использования
omega_bs = [0.3, 0.7]; % Границы полосы заграждения
[num_bs, den_bs] = lp2bs_custom(num_lp, den_lp, omega_bs);
disp('НЧ -> Полосозаградительный (ручное преобразование):');
disp(num_bs);
disp(den_bs);

