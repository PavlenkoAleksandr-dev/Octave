% Лабораторная работа №6: Фильтрация аналоговых сигналов в пространстве состояний

pkg load signal; % Загрузка пакета для работы с сигналами

% 1. Разработка аналогового фильтра
order = 4;  % порядок фильтра
wc = 1;     % частота среза (рад/с)
[z, p, k] = buttap(order); % Аналоговый прототип Баттерворта
[num, den] = zp2tf(z, p, k); % Преобразование в полиномы (передаточная функция)

% Масштабирование для частоты среза wc
den = den .* wc.^(length(den) - 1:-1:0); % Масштабируем коэффициенты знаменателя
num = num .* wc.^(length(num) - 1:-1:0); % Масштабируем коэффициенты числителя

[A, B, C, D] = tf2ss(num, den); % Преобразование в пространство состояний

% Построение АЧХ и ФЧХ
w = logspace(-1, 2, 500); % Логарифмическое распределение частот
freqs(num, den, w); % Частотная характеристика фильтра
title('Частотная характеристика фильтра (АЧХ и ФЧХ)');

% 2. Генерация аналогового зашумленного сигнала
fs = 100; % частота дискретизации (Гц)
t = 0:1/fs:10; % временная шкала (с)
signal = sin(2*pi*0.5*t) + 0.5*sin(2*pi*5*t) + 0.2*sin(2*pi*10*t); % Исходный сигнал
noise = 0.1 * randn(size(t)); % Белый шум
noisy_signal = signal + noise; % Зашумленный сигнал

% Спектр исходного сигнала
figure;
plot(t, noisy_signal);
title('Исходный зашумленный сигнал');
xlabel('Время (с)');
ylabel('Амплитуда');

% 3. Решение дифференциальных уравнений
% Определение правой части системы дифференциальных уравнений
rhs = @(t, x) A*x + B*interp1(t, noisy_signal, t, 'linear', 0); % Правая часть СДУ

% Решение СДУ
x0 = zeros(size(A, 1), 1); % Начальное условие
[t_sol, x_sol] = ode45(rhs, t, x0); % Решение СДУ
filtered_signal = C*x_sol' + D*interp1(t, noisy_signal, t, 'linear', 0); % Выходной сигнал

% 4. Построение графиков
% АЧХ и спектр сигнала
figure;
freqz(num, den, 1024, fs); % АЧХ фильтра
title('АЧХ фильтра');

% Исходный и отфильтрованный сигналы
figure;
plot(t, noisy_signal, 'r', t, filtered_signal, 'b');
legend('Исходный сигнал', 'Отфильтрованный сигнал');
title('Сравнение исходного и отфильтрованного сигналов');
xlabel('Время (с)');
ylabel('Амплитуда');

% Вывод
disp('Фильтрация выполнена успешно. Проверьте графики для анализа достоверности.');
