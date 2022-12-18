(def input (-> (slurp "./input.txt") (string/trim)))

(def lines (string/split "\n" input))
(def positions @{})

(each line lines (put positions line true))

(var score 0)

(def EXPOSED @{})
(def VISITED @{})

(def SIZE 22)

(defn get-key [[x y z]] (string x "," y "," z))

(defn is-exposed [[x y z]]
  (cond
    (<= x 0) true
    (<= y 0) true
    (<= z 0) true
    (>= x SIZE) true
    (>= y SIZE) true
    (>= z SIZE) true
    (get EXPOSED (get-key [x y z]))))

(defn check-pos [[x y z]]
  (unless (get VISITED (get-key [x y z]))
    (put VISITED (get-key [x y z]) true)

    (def sides [[(- x 1) y z]
                [(+ x 1) y z]
                [x (- y 1) z]
                [x (+ y 1) z]
                [x y (- z 1)]
                [x y (+ z 1)]])
    (def exposed-sides (filter is-exposed sides))
    (def empty (not (get positions (get-key [x y z]))))

    (if empty
      (if (> (length exposed-sides) 0)
        (put EXPOSED (get-key [x y z]) true))
      (+= score (count
                  |(not (get positions (get-key $)))
                  exposed-sides)))))

(defn process-side [a b depth]
  (def end (- SIZE depth 1))
  (def top [a b depth])
  (def bottom [a b end])
  (def left [depth b a])
  (def right [end b a])
  (def front [a depth b])
  (def back [a end b])
  (def positions [top bottom left right front back])

  (each pos positions (check-pos pos)))

(defn run-pass []
  (for depth 0 SIZE
    (for a depth (- SIZE depth)
      (for b depth (- SIZE depth) (process-side a b depth)))))


(defn part1 []
  (each line lines
    (def [x y z] (map int/s64 (string/split "," line)))

    (unless (get positions (get-key [(+ x 1) y z])) (++ score))
    (unless (get positions (get-key [(- x 1) y z])) (++ score))

    (unless (get positions (get-key [x (+ y 1) z])) (++ score))
    (unless (get positions (get-key [x (- y 1) z])) (++ score))

    (unless (get positions (get-key [x y (+ z 1)])) (++ score))
    (unless (get positions (get-key [x y (- z 1)])) (++ score))))

(defn part2 []
  (var prev -1)

  (while (not= prev score)
    (set prev score)
    (set score 0)
    (run-pass)
    (table/clear VISITED)))

(if (= (os/getenv "part") "part2") (part2) (part1))
(print score)
