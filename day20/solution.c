#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Value {
  long value;
  long position;
  struct Value *next;
} Value;

int main(int argc, char **argv) {
  FILE *file = fopen("./input.txt", "r");

  const char *part = getenv("part");
  const _Bool part1 = !part || strcmp(part, "part2");
  const long key = part1 ? 1 : 811589153;
  int mix = part1 ? 1 : 10;

  Value *head = NULL;
  Value *prev = NULL;
  int length = 0;

  char l[7];
  int c;
  int n = 0;
  while ((c = getc(file)) != EOF) {
    if (c == '\n') {
      l[n++] = '\0';
      Value *v = malloc(sizeof(Value));
      if (v == NULL) {
        printf("malloc failed\n");
        return -1;
      }
      v->value = atoi(l) * key;
      v->position = length++;
      if (head) {
        prev->next = v;
        prev = v;
      } else {
        head = v;
        prev = head;
      }
      n = 0;
      l[0] = '\n';
    } else {
      l[n++] = c;
    }
  }

  Value *target = NULL;
  Value *prev_target = NULL;
  Value *current = NULL;

  while (mix--) {
    for (int i = 0; i < length; i++) {
      long target_pos = 0;
      target = head;
      prev_target = NULL;
      while (target->position != i) {
        prev_target = target;
        target = target->next;
        target_pos++;
      }

      long to_add = target->value + target_pos;
      long remainder = to_add % (length - 1);
      long new_pos = remainder <= 0 ? length + remainder - 1 : remainder;

      if (prev_target) {
        prev_target->next = target->next;
      } else {
        head = target->next;
      }

      current = head;
      int n = 0;
      while (n < new_pos - 1) {
        current = current->next;
        n++;
      }
      target->next = current->next;
      current->next = target;
    }
  }

  Value *list[5000];
  current = head;
  int index0 = 0;
  int index = 0;

  while (current) {
    if (current->value == 0)
      index0 = index;
    list[index] = current;
    current = current->next;
    index++;
  }

  long sum = 0;
  for (long n = 1; n < 4; n++) {
    sum += list[(n * 1000 + index0) % length]->value;
  }

  printf("%ld\n", sum);
}
